# frozen_string_literal: true

module Darthjee
  module CoreExt
    module Hash
      module Transposeable
        # Transpose matrix swapping keys by values
        #
        # @return [::Hash]
        #
        # @example
        #   hash = {
        #     key1: :value1,
        #     key2: :value2,
        #   }
        #
        #   hash.transpose # returns {
        #                  #   value1: :key1,
        #                  #   value2: :key2
        #                  # }
        def transpose!
          aux = dup
          keys.each { |k| delete(k) }
          aux.each do |k, v|
            self[v] = k
          end
          self
        end

        # Transpose matrix swapping keys by values
        #
        # @return [::Hash]
        #
        # @example
        #   hash = {
        #     key1: :value1,
        #     key2: :value2,
        #   }
        #
        #   hash.transpose # changes hash to {
        #                  #   value1: :key1,
        #                  #   value2: :key2
        #                  # }
        def transpose
          {}.tap do |new_hash|
            each do |k, v|
              new_hash[v] = k
            end
          end
        end
      end
    end
  end
end
