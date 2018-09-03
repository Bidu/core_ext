# frozen_string_literal: true

module Darthjee
  module CoreExt
    module Array
      class HashBuilder
        attr_accessor :values, :keys

        def initialize(values, keys)
          @values = values.dup
          @keys = keys.dup
        end

        def build
          fixes_sizes

          ::Hash[[keys, values].transpose]
        end

        private

        def fixes_sizes
          return unless needs_resizing?
          values.concat ::Array.new(keys.size - values.size)
        end

        def needs_resizing?
          keys.size > values.size
        end
      end
    end
  end
end
