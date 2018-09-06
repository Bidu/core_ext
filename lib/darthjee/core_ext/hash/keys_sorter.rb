# frozen_string_literal: true

module Darthjee
  module CoreExt
    module Hash
      class KeysSorter
        def initialize(hash, recursive: true)
          @hash = hash
          @recursive = recursive
        end

        def sort
          {}.tap do |new_hash|
            sorted_keys.each do |key|
              new_hash[key] = change_value(hash[key])
            end
          end
        end

        private

        def sorted_keys
          hash.keys.sort
        end

        def change_value(value)
          return value unless value.is_a?(Hash) && recursive
          value.sort_keys(recursive: true)
        end

        attr_reader :hash, :recursive
      end
    end
  end
end
