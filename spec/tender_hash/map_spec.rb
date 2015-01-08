require 'spec_helper'

describe TenderHash::Map do
  let(:hash) do { bob: 32, alice: 'cooper', johnny: '13' } end
  let(:mapper) { TenderHash::Map.new(hash) }

  describe "#to_h" do
    context "given an empty source hash" do
      it "returns an new empty hash" do
        hash = {}
        TenderHash::Map.new(hash).to_h.tap do |new_hash|
          expect( new_hash ).to be_empty
          expect( new_hash ).to_not equal hash
        end
      end
    end

    context "given no rules are specified" do
      it "returns an empty hash" do
        hash = { hello: 'there' }
        expect( TenderHash::Map.new(hash).to_h ).to be_empty
      end
    end
  end

  describe "#key" do
    it "keeps the specified key" do
      mapper.key :bob
      expect( mapper.to_h ).to eql( bob: 32 )
    end

    it "adds a key with nil value if the key didn't exist in the source hash" do
      mapper.key :not_existing
      expect( mapper.to_h ).to eql( not_existing: nil )
    end

    describe "cast_to option" do
      it "calls the given proc with the string and assigns the output to corresponding key" do
        mapper.key :alice, cast_to: -> (v) { v.upcase }
        expect( mapper.to_h ).to eql( alice: 'COOPER' )
      end

      it "calls to_i on the mapped value if cast_to is set to integer" do
        mapper.key :johnny, cast_to: :integer
        expect( mapper.to_h ).to eql( johnny: 13 )
      end

      it "calls to_s on the mapped value if cast_to is set to string" do
        mapper.key :bob, cast_to: :string
        expect( mapper.to_h ).to eql( bob: '32' )
      end

      describe "boolean" do
        it "sets it to true when `true`" do
          mapper.source = { true: 'true' }
          mapper.key :true, cast_to: :boolean
          expect( mapper.to_h ).to eql( true: true )
        end

        it "sets it to true when equal to 1" do
          mapper.source = { true: 1 }
          mapper.key :true, cast_to: :boolean
          expect( mapper.to_h ).to eql( true: true )
        end

        it "sets it to false when `false`" do
          mapper.source = { false: 'false' }
          mapper.key :false, cast_to: :boolean
          expect( mapper.to_h ).to eql( false: false )
        end

        it "sets it to false when equal to 0" do
          mapper.source = { false: 'false' }
          mapper.key :false, cast_to: :boolean
          expect( mapper.to_h ).to eql( false: false )
        end

        it "doesn't change its value in any other case" do
          value = double
          mapper.source = { double: value  }
          mapper.key :double, cast_to: :boolean
          expect( mapper.to_h ).to eql( double: value )
        end

      end
    end

    describe "default options" do
      it "disregards the default option when there's a value for the specified key" do
        mapper.key :bob, default: 'hello'
        expect( mapper.to_h ).to eql( bob: 32 )
      end

      it "sets the default when there's no value for the specified key" do
        mapper.key :new, cast_to: :string, default: "new"
        expect( mapper.to_h ).to eql( new: 'new' )
      end
    end
  end

  describe "#map_key" do
    it "updates the key on the return hash" do
      mapper.map_key :bob, :BOB
      mapper.map_key :alice, :Alice
      expect( mapper.to_h ).to eql( BOB: 32, Alice: 'cooper' )
    end
  end

  describe "#scope" do
    it "allows to nest hashes" do
      mapper.scope :subkey do
        map_key :bob, :BOB
      end

      expect( mapper.to_h ).to eql( subkey: { BOB: 32 })
    end

    it "allows multiple nesting" do
      mapper.scope :subkey do
        map_key :alice, :ALICE
        scope :nested_subkey do
          key :bob
        end
      end

      expect( mapper.to_h ).to eql(
        {
          subkey: {
            ALICE: 'cooper',
            nested_subkey: { bob: 32 }
          }
        }
      )
    end

  end
end

