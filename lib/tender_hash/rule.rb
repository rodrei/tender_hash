module TenderHash
  class Rule

    def initialize(old_key, new_key=nil, options={})
      @old_key = old_key
      @new_key = new_key || old_key
      @caster  = Caster.for(options[:cast_to])
      @default = options[:default]
    end

    def apply(old_hash, new_hash)
      new_value = cast_value(old_hash[@old_key])
      new_hash[@new_key] = new_value.nil? ? @default : new_value
    end

    private

    def cast_value(val)
      @caster.call(val) unless val.nil?
    end

  end
end
