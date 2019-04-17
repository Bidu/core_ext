# frozen_string_literal: true

module Darthjee
  module CoreExt
    module Hash
      # @api private
      #
      # @author Darthjee
      #
      # class responsible for squashing a hash
      #
      # @see Transformable#squash
      # @see Transformable#to_deep_hash
      #
      # @example (see Transformable#squash)
      # @example (see #squash)
      class Squasher
        attr_reader :joiner

        # @param joiner [::String] string used to join keys
        def initialize(joiner = '.')
          @joiner = joiner
        end

        # Squash a hash creating a new hash
        #
        # Squash the hash so that it becomes a single level
        # hash merging the keys of outter and inner hashes
        #
        # @param hash [::Hash] hash to be squashed
        #
        # @return [::Hash]
        #
        # @example Simple usage
        #   hash = {
        #     person: [{
        #       name: %w[John Wick],
        #       age: 22
        #     }, {
        #       name: %w[John Constantine],
        #       age: 25
        #     }]
        #   }
        #
        #   squasher = Darthjee::CoreExt::Hash::Squasher.new
        #
        #   squasher.squash(hash) # changes hash to {
        #                         #   'person[0].name[0]' => 'John',
        #                         #   'person[0].name[1]' => 'Wick',
        #                         #   'person[0].age'  => 22,
        #                         #   'person[1].name[0]' => 'John',
        #                         #   'person[1].name[1]' => 'Constantine',
        #                         #   'person[1].age'  => 25
        #                         # }
        #
        # @example Custom joiner
        #   hash = {
        #     person: {
        #       name: 'John',
        #       age: 22
        #     }
        #   }
        #
        #   squasher = Darthjee::CoreExt::Hash::Squasher.new('> ')
        #
        #   squasher.squash(hash) # changes hash to {
        #                         #   'person> name' => 'John',
        #                         #   'person> age'  => 22
        #                         # }
        def squash(hash)
          hash.keys.each do |key|
            next unless hash[key].is_any?(Hash, Array)

            value = hash.delete(key)
            add_value_to_hash(hash, key, value)
          end
          hash
        end

        private

        # @private
        #
        # Perform squashing on array
        #
        # @param key [::String] key to be prepended on
        #   hash keys
        # @param array [::Array] array to be squashed
        #
        # @return [::Hash] hash with indexed keys
        def squash_array(key, array)
          array.map.with_index.inject({}) do |hash, (element, index)|
            new_key = "#{key}[#{index}]"
            add_value_to_hash(hash, new_key, element)
          end
        end

        # @private
        #
        # Add positioned values to a hash
        #
        # @param hash [::Hash] hash to receive the values
        # @param key [::String] String to be prepended
        #
        # @overload add_value_to_hash(hash, key, sub_hash)
        #   @param sub_hash [::Hash] subhash to be squashed
        #     key prepended and merged into hash
        #
        # @overload add_value_to_hash(hash, key, array)
        #   @param array [::Array] array to be squashed into
        #     {::Hash} and merged into hash
        #
        # @overload add_value_to_hash(hash, key, object)
        #   @param object [::Object] object to be treated
        #     as value
        #
        # @return [::Hash]
        def add_value_to_hash(hash, key, element)
          case element
          when Hash
            value = squash(element)
            hash.merge! prepend_to_keys(key, value)
          when Array
            hash.merge! squash_array(key, element)
          else
            hash.merge!(key => element)
          end
        end

        # @private
        #
        # Appends prefix to all keys of a hash
        #
        # @param prefix [::String] prefix to be prepended
        # @param hash [::Hash] original hash to me changed
        #   (already squashed)
        #
        # @return [::Hash] new hash already squashed
        def prepend_to_keys(prefix, hash)
          hash.inject({}) do |subhash, (key, value)|
            new_key = [prefix, key].join(joiner)
            subhash.merge!(new_key => value)
          end
        end
      end
    end
  end
end
