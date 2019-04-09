# frozen_string_literal: true

module Darthjee
  module CoreExt
    module Hash
      # @api private
      #
      # @author Darthjee
      #
      # Class responsible for sorting keys of a Hash
      class KeysSorter
        # @param hash [::hash] hash to be sorted
        # @param recursive [::TrueClass,::FalseClass]
        #   flag indicating to perform transformation
        #   recursively
        def initialize(hash, recursive: true)
          @hash = hash
          @recursive = recursive
        end

        # Creates a new Hash sorting it's keys
        #
        # @return [::Hash] new hash
        #
        # @example (see KeyChangeable#sort_keys)
        #
        # @example Simple Usage
        #   hash = { key: 10, a_key: { z: 5, a: 10 } }
        #   sorter = Darthjee::CoreExt::Hash::KeysSorter.new(hash)
        #
        #   sorter.sort  # changes hash to {
        #                #   a_key: { a: 10, z: 5 },
        #                #   key: 10
        #                # }
        def sort
          hash.tap do
            sorted_keys.each do |key|
              hash[key] = change_value(hash.delete(key))
            end
          end
        end

        private

        attr_reader :hash, :recursive

        # @api private
        # @private
        #
        # Returns all keys sorted
        #
        # @return [::Array<::Object>]
        def sorted_keys
          hash.keys.sort
        end

        # @api private
        # @private
        #
        # Applies recursion when needed
        #
        # @return [::Object]
        def change_value(value)
          return value unless recursive
          return value unless value.is_a?(Hash)
          self.class.new(value).sort
        end
      end
    end
  end
end
