require "hash_mapper/version"
require "hash_mapper/map"
require "hash_mapper/rule"
require "hash_mapper/scope_rule"

module HashMapper

  def self.map(hash, &block)
    raise ArgumentError unless block_given?

    Map.new(hash, &block).to_h
  end

end

