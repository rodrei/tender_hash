require "tender_hash/version"
require "tender_hash/map"
require "tender_hash/rule"
require "tender_hash/scope_rule"
require "tender_hash/caster"

module TenderHash

  def self.map(hash, &block)
    raise ArgumentError unless block_given?

    Map.new(hash, &block).to_h
  end

end

