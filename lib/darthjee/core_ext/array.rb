# frozen_string_literal: true

module Darthjee
  module CoreExt
    # @api public
    #
    # Module containing new usefull methods to Ruby vanilla Array
    module Array
      autoload :HashBuilder, 'darthjee/core_ext/array/hash_builder'

      # Returns a Hash where the values are the elements of the array
      #
      # @param [::Array<::Object>] keys The keys of the hash
      #
      # @return [::Hash] hash built pairing the keys and values
      #
      # @example Creation of hash with symbol keys
      #   array = %w[each word one key]
      #   array.as_hash(%i[a b c d])
      #   # returns
      #   # { a: 'each', b: 'word', c: 'one', d: 'key' }
      def as_hash(keys)
        Array::HashBuilder.new(self, keys).build
      end

      # Calculate the average of all values in the array
      #
      # @return [::Float] average of all numbers
      #
      # @example Average of array of integer values
      #   array = [1, 2, 3, 4]
      #   array.average # returns 2.5
      #
      # @example An empty array
      #   [].average # returns 0
      def average
        return 0 if empty?
        sum * 1.0 / length
      end

      # Maps the array using the given methods on each element of the array
      #
      # @param [::String,::Symbol] methods List of methods to be called
      #   sequentially on each element of the array
      #
      # @yield [element] block to be called on each element performing
      #   a final mapping
      # @yieldparam [::Object] element element that will receive
      #   the method calls in chain
      #
      # @return [::Array] Array with the result of all method calls in chain
      #
      # @example Mapping to string out of float size of strings
      #   words = %w(big_word tiny oh_my_god_such_a_big_word)
      #   words.chain_map(:size, :to_f, :to_s) # returns ["8.0", "4.0", "25.0"]
      #
      # @example Mapping with a block mapping at the end
      #   words = %w(big_word tiny oh_my_god_such_a_big_word)
      #
      #   output = words.chain_map(:size) do |size|
      #     (size % 2).zero? ? 'even size' : 'odd size'
      #   end  # returns ["even size", "even size", "odd size"]
      def chain_map(*methods, &block)
        result = methods.inject(self) do |array, method|
          array.map(&method)
        end

        return result unless block_given?
        result.map(&block)
      end

      # Maps array chain fetching the keys of the hashes inside
      #
      # @param [::String,::Symbol] keys list of keys to be
      # fetched from hashes inside
      #
      # @return [::Array] Array resulting of chain fetch of keys
      #
      # @example Multi level hash mapping
      #   array = [
      #     { a: { b: 1 }, b: 2 },
      #     { a: { b: 3 }, b: 4 }
      #   ]
      #   array,mapk(:a)     # returns [{ b: 1 }, { b: 3 }]
      #   array.mapk(:a, :b) # returns [1, 3]
      #
      # @example Key missing
      #   array = [
      #     { a: { b: 1 }, b: 2 },
      #     { a: { b: 3 }, b: 4 }
      #   ]
      #   array.mapk(:c)     # returns [nil, nil]
      #   array.mapk(:c, :d) # returns [nil, nil]
      def mapk(*keys)
        keys.inject(self) do |enum, key|
          enum.map do |hash|
            hash&.[] key
          end
        end
      end

      # Joins elements in a string using a proc
      #
      # Uses the proc given
      # to convert elements to Strig and a block for joining
      #
      # @param [Proc] mapper Proc that will be used to map values
      # to string before joining
      #
      # @return [String]
      #
      # @yield [previous, nexte]
      #   defines the string to be used to join the previous and
      #   next element
      # @yieldparam [::Object] previous previous element that was joined
      # @yieldparam [::Object] nexte next element that will be joined
      #
      # @example Addition of positive and negative numbers
      #   [1, 2, -3, -4, 5].procedural_join do |_previous, nexte|
      #     nexte.positive? ? '+' : ''
      #   end     # returns '1+2-3-4+5'
      #
      # @example Spaced addition of positive and negative numbers
      #   mapper = proc { |value| value.to_f.to_s }
      #   array.procedural_join(mapper) do |_previous, nexte|
      #     nexte.positive? ? ' +' : ' '
      #   end     # returns '1.0 +2.0 -3.0 -4.0 +5.0'
      def procedural_join(mapper = proc(&:to_s))
        return '' if empty?
        list =     dup
        previous = first
        list[0] = mapper.call(previous).to_s

        list.inject do |string, value|
          link =        yield(previous, value) if block_given?
          next_string = mapper.call(value)
          previous = value

          "#{string}#{link}#{next_string}"
        end
      end

      # Reeturns a random element of the array without altering it
      #
      # @return [Object] random element of the array
      #
      # @example Picking a random element of numeric array
      #   array = [10, 20, 30]
      #   array.random # might return 10, 20 or 30
      #   array        # returns unchanged [10, 20, 30]
      def random
        self[Random.rand(size)]
      end

      # Reeturns a random element of the array removing it from the array
      #
      # @return [Object] random element of the array
      #
      # @example Slicing a random element of a numeric array
      #   array = [10, 20, 30]
      #   array.random! # might return 10, 20 or 30 ... lets say 20
      #   array         # returns changed [20, 30]
      def random!
        slice!(Random.rand(size))
      end
    end
  end
end

# Ruby Array received
#
# - mapk
# - procedural_join
# - chain_map
# - as_hash
# - random
# - random!
#
# @see Darthjee::CoreExt::Array
class Array
  include Darthjee::CoreExt::Array
end
