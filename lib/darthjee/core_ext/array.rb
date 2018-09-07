# frozen_string_literal: true

module Darthjee
  module CoreExt
    # Module containing new usefull methods to Ruby vanilla Array
    module Array
      autoload :HashBuilder, 'darthjee/core_ext/array/hash_builder'

      # Maps array chain fetching the keys of the hashes inside
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
