module TenderHash
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
end
