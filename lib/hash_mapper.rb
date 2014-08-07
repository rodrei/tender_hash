require "hash_mapper/version"

module HashMapper
  def self.map(hash, &block)
    raise ArgumentError unless block_given?

    Map.new(hash, &block).to_h
  end

  class Map
    def initialize(hash=nil, &block)
      @old_hash = hash || {}
      @rules = []
      instance_exec(&block) if block_given?
    end

    def source=(hash)
      @old_hash = hash
    end

    def map_key(old, new, options={})
      @rules << Rule.new(old, new, options)
    end

    def key(key, options={})
      map_key(key, key, options)
    end

    def scope(key, &block)
      scope = ScopeRule.new(key, &block)
      @rules << scope
      scope.map
    end

    def to_h
      {}.tap do |new_hash|
        @rules.each do |rule|
          rule.apply(@old_hash, new_hash)
        end
      end
    end
  end

  class Rule
    def initialize(old_key, new_key=nil, options={})
      @old_key = old_key
      @new_key = new_key || old_key
      @cast_to = options[:cast_to] && options[:cast_to].to_sym
      @default = options[:default]
    end


    def apply(old_hash, new_hash)
      new_value = cast_value(old_hash[@old_key]) unless old_hash[@old_key].nil?
      new_hash[@new_key] = new_value.nil? ? @default : new_value
    end

    private

    def cast_value(val)
      case @cast_to
      when :integer
        val.to_i
      when :string
        val.to_s
      when :boolean
        cast_to_boolean(val)
      else
        val
      end
    end

    def cast_to_boolean(val)
      case val
      when 'true', 1
        true
      when 'false', 0
        false
      else
        val
      end
    end

  end

  class ScopeRule
    def initialize(key, &block)
      raise ArgumentError unless block_given?
      @key = key
      @block = block
    end

    def map
      @map ||= Map.new
    end

    def apply(old, new, options={})
      map.source = old
      map.instance_exec(&@block)
      new[@key] = map.to_h
    end
  end

end
