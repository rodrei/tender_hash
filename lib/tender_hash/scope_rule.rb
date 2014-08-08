module TenderHash
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

