# frozen_string_literal: true

module Darthjee
  module CoreExt
    module Hash
      module Transformable
        # Merges both hashes not adding keys that don't
        # exist in the original hash
        #
        # @param [::Hash] other other hash to be merged
        #
        # @return [::Hash] the merged hash
        #
        # @example merging of hashes with some clashing keys
        #   hash = { a: 1, b: 2, c: 3 }
        #   other = { b: 4, 'c' => 5, e: 6 }
        #
        #   hash.exclusive_merge(other) # returns { a: 1, b: 4, c: 3 }
        #   hash                        # returns { a: 1, b: 2, c: 3 }
        def exclusive_merge(other)
          dup.exclusive_merge!(other)
        end

        # Merges both hashes not adding keys that don't
        # exist in the original hash
        #
        # @param [::Hash] other other hash to be merged
        #
        # @return [::Hash] the merged hash
        #
        # @example merging of hashes with some clashing keys
        #   hash = { a: 1, b: 2, c: 3 }
        #   other = { b: 4, 'c' => 5, e: 6 }
        #
        #   hash.exclusive_merge!(other) # returns { a: 1, b: 4, c: 3 }
        #   hash                         # returns { a: 1, b: 4, c: 3 }
        def exclusive_merge!(other)
          merge!(other.slice(*keys))
        end

        # Run map block where each pair key, value is mapped
        # to a new value to be assigned in the same key on the
        # returned hash
        #
        # @return new Hash made with the pairs key => mapped_value
        #
        # @yield (key, value) block returning the new value
        #
        # @see ToHashMapper
        #
        # @example mapping to size of the original words
        #   hash = { a: 'word', b: 'bigword', c: 'c' }
        #
        #   new_hash = hash.map_to_hash do |key, value|
        #     "#{key}->#{value.size}"
        #   end
        #
        #   new_hash # returns { a: 'a->4', b: 'b->7', c: 'c->1' }
        def map_to_hash
          map do |key, value|
            [key, yield(key, value)]
          end.to_h
        end

        # Squash the hash returning a single level hash
        #
        # The squashing happens by merging the keys of
        # outter and inner hashes
        #
        # This operation is the oposite of {#to_deep_hash}
        #
        # @param joiner [::String] String to be used when
        #   joining keys
        #
        # @return [::Hash] A new hash
        #
        # @see Squash::Builder
        # @see #to_deep_hash
        #
        # @example Simple Usage
        #   hash = { name: { first: 'John', last: 'Doe' } }
        #
        #   hash.squash # returns {
        #               #   'name.first' => 'John',
        #               #   'name.last'  => 'Doe'
        #               # }
        #
        # @example Reverting a #to_deep_hash call
        #   person_data = {
        #     person: [{
        #       name: %w[John Wick],
        #       age: 22
        #     }, {
        #       name: %w[John Constantine],
        #       age: 25
        #     }]
        #   }
        #   person = person_data.to_deep_hash
        #
        #   person.squash # returns {
        #                 #   'person' => [{
        #                 #     'name' => %w[John Wick],
        #                 #     'age' => 22
        #                 #   }, {
        #                 #     'name' => %w[John Constantine],
        #                 #     'age' => 25
        #                 #   }]
        #                 # }
        #
        # @example Giving a custom joiner
        #   hash = {
        #     links: {
        #       home: '/',
        #       products: '/products'
        #     }
        #   }
        #
        #   hash.squash('> ')  # returns {
        #                      #   'links> home' => '/',
        #                      #   'links> products' => '/products'
        #                      # }
        def squash(joiner = '.')
          Hash::Squasher.new(joiner).squash(deep_dup)
        end

        # Squash the hash so that it becomes a single level hash
        #
        # The squashing happens by merging the keys of
        # outter and inner hashes
        #
        # This operation is the oposite of {#to_deep_hash!}
        #
        # @param joiner [::String] String to be used when
        #   joining keys
        #
        # @return [::Hash] A new hash
        #
        # @see Squash::Builder
        # @see #to_deep_hash!
        #
        # @example (see #squash)
        def squash!(joiner = '.')
          Hash::Squasher.new(joiner).squash(self)
        end

        # Creates a new hash of multiple levels from a one level
        # hash
        #
        # this operation is the oposite from {#squash}
        #
        # @return [::Hash] A multi-level hash
        #
        # @see Hash::DeepHashConstructor
        # @see #squash
        #
        # @example With custom separator
        #   hash = {
        #     'person[0]_name_first' => 'John',
        #     'person[0]_name_last'  => 'Doe',
        #     'person[1]_name_first' => 'John',
        #     'person[1]_name_last'  => 'Wick'
        #   }
        #
        #   hash.to_deep_hash('_') # return {
        #                          #   'person' => [{
        #                          #     'name' => {
        #                          #       'first' => 'John',
        #                          #       'last'  => 'Doe'
        #                          #   }, {
        #                          #     'name' => {
        #                          #       'first' => 'John',
        #                          #       'last'  => 'Wick'
        #                          #     }
        #                          #   }]
        #                          # }
        #
        # @example Reverting the result of a squash
        #   person = {
        #     person: [{
        #       name: ['John', 'Wick'],
        #       age:  23
        #     }, {
        #       name: %w[John Constantine],
        #       age:  25
        #     }]
        #   }
        #   person_data = person.squash
        #
        #   person_data.to_deep_hash
        #   # returns {
        #   #   'person' => [{
        #   #     'name' => ['John', 'Wick'],
        #   #     'age'  => 23
        #   #   }, {
        #   #     'name' => %w[John Constantine],
        #   #     'age'  => 25
        #   #   }]
        #   # }
        def to_deep_hash(separator = '.')
          Hash::DeepHashConstructor.new(separator).deep_hash(deep_dup)
        end

        # Changes hash to be a multiple level hash
        #
        # this operation is the oposite from {#squash!}
        #
        # @return [::Hash] Self changed to be a multi-level hash
        #
        # @see Hash::DeepHashConstructor
        # @see #squash
        #
        # @example (see #to_deep_hash)
        def to_deep_hash!(separator = '.')
          Hash::DeepHashConstructor.new(separator).deep_hash(self)
        end
      end
    end
  end
end
