module TenderHash
  class Rule

    def initialize(old_key, new_key=nil, options={})
      @old_key = old_key
      @new_key = new_key || old_key
      @cast_to = options[:cast_to]
      @default = options[:default]
    end


    def apply(old_hash, new_hash)
      new_value = cast_value(old_hash[@old_key]) unless old_hash[@old_key].nil?
      new_hash[@new_key] = new_value.nil? ? @default : new_value
    end

    private

    def cast_value(val)
      return @cast_to.call(val) if @cast_to.respond_to?(:call)
      case @cast_to && @cast_to.to_sym
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
end
