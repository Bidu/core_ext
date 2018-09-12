# frozen_string_literal: true

module Darthjee
  module CoreExt
    # Module containing new usefull methods to Ruby vanilla Array
    module Array
      autoload :HashBuilder, 'darthjee/core_ext/array/hash_builder'

      # Maps array chain fetching the keys of the hashes inside
      #
      # @param [String/Symbol] keys list of keys to be
      # fetched from hashes inside
      #
      # @example
      #   array = [
      #     { a: { b: 1 }, b: 2 },
      #     { a: { b: 3 }, b: 4 }
      #   ]
      #   array,mapk(:a)     # returns [{ b: 1 }, { b: 3 }]
      #   array.mapk(:a, :b) # returns [1, 3]
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
      # to convert elements to Strig and a block for joining
      #
      # @param [Proc] mapper Proc that will be used to map values
      # to string before joining
      #
      # @yield [prev, val]
      #   defines the string to be used to join the previous and
      #   next element
      #
      # @example
      #   [1, 2, -3, -4, 5].procedural_join do |_previous, nexte|
      #     nexte.positive? ? '+' : ''
      #   end     # returns '1+2-3-4+5'
      #
      # @example
      #   mapper = proc { |value| value.to_f.to_s }
      #   array.procedural_join(mapper) do |_previous, nexte|
      #     nexte.positive? ? ' +' : ' '
      #   end     # returns '1.0 +2.0 -3.0 -4.0 +5.0'
      def procedural_join(mapper = proc(&:to_s))
        return '' if empty?
        list = dup
        prev = first
        list[0] = mapper.call(prev).to_s

        list.inject do |string, val|
          j = yield(prev, val) if block_given?
          "#{string}#{j}#{mapper.call(val)}".tap do
            prev = val
          end
        end
      end

      # Maps the array using the given methods on each
      # element of the array
      #
      # @param [String/Symbol] methods List of methods to be called sequentially
      #   on each element of the array
      #
      # @yield [element] block to be called on each element performing
      #   a final mapping
      #
      # @example
      #   words = %w(big_word tiny oh_my_god_such_a_big_word)
      #   words.chain_map(:size, :to_f, :to_s) # returns ["8.0", "4.0", "25.0"]
      #
      # @example
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

      def as_hash(keys)
        Array::HashBuilder.new(self, keys).build
      end

      def random
        self[rand(size)]
      end

      def random!
        slice!(rand(size))
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
