# frozen_string_literal: true

module Darthjee
  module CoreExt
    module Array
      # Class responsible for building a Hash from 2 arrays
      #
      # @attribute [Array] values
      #   values of the hash to be built
      # @attribute [Array] keys
      #   keys of the hash to be built
      #
      # @example Building the hash from the array
      #   values = [10, 20, 30]
      #   keys   = %i[a b c]
      #   builder = Darthjee::CoreExt::Array::HashBuilder.new(values, keys)
      #
      #   builder.build  # returns { a: 10, b: 20, c: 30 }
      #
      # @example Rebuilding a hash from values and keys
      #   hash = { a: 20, b: 200, c: 2000 }
      #   builder = Darthjee::CoreExt::Array::HashBuilder.new(
      #     hash.values,
      #     hash.keys
      #   )
      #
      #   builder.build == hash   # returns true
      class HashBuilder
        attr_accessor :values, :keys

        # @param [Array] values List of values of the hash
        # @param [Array] keys List of keys of the hash
        def initialize(values, keys)
          @values = values.dup
          @keys = keys.dup
        end

        # Builds the hash
        # @return [Hash] Hash whose keys and values are paired
        #   from builder's keys and values
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
