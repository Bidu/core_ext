class Hash
  class ValueChanger
    class DummyIteractor
      def initialize(*array)
        @array = array
      end

      delegate :each, :map, :to_a, to: :array

      private

      attr_reader :array
    end
  end
end
