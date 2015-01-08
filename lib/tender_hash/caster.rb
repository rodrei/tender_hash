module TenderHash
  class Caster
    def self.for(cast_to)
      if cast_to.respond_to?(:call)
        cast_to
      else
        Default.new(cast_to)
      end
    end

    class Default

      def initialize(cast_to)
        @cast_to = cast_to
      end

      def call(val)
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

end
