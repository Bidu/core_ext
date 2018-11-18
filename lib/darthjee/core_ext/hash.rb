# frozen_string_literal: true

require 'darthjee/core_ext/hash/key_changeable'
require 'darthjee/core_ext/hash/transposeable'
require 'darthjee/core_ext/hash/transformable'

module Darthjee
  module CoreExt
    module Hash
      autoload :ChainFetcher,        "#{PATH}/hash/chain_fetcher"
      autoload :DeepHashConstructor, "#{PATH}/hash/deep_hash_constructor"
      autoload :KeyChanger,          "#{PATH}/hash/key_changer"
      autoload :KeysSorter,          "#{PATH}/hash/keys_sorter"
      autoload :Squasher,            "#{PATH}/hash/squasher"
      autoload :ValueChanger,        "#{PATH}/hash/value_changer"
      autoload :ToHashMapper,        "#{PATH}/hash/to_hash_mapper"

      include Hash::KeyChangeable
      include Hash::Transposeable
      include Hash::Transformable

      ########################################
      # Fetching methods
      #########################################

      # Crawls through the hash fetching a key value from inside it
      #
      # this is the equivalent of chaining several calls to fetch method
      #
      # ```
      #   hash.chain_fetch(:key1, :key2)
      #   hash.fetch(:key1).fetch(:key2)
      # ```
      #
      # @example
      #   hash = {
      #     a: {
      #       b: { c: 1, d: 2 }
      #     }
      #   }
      #
      #   hash.chain_fetch(:a, :b, :c) # returns 1
      #   hash.chain_fetch(:a, :c, :d) # raises KeyError
      #   hash.chain_fetch(:a, :c, :d) { 10 } # returns 10
      #   hash.chain_fetch(:a, :c, :d) { |key, _| key } # returns :c
      #   hash.chain_fetch(:a, :c, :d) { |_, missing| missing } # returns [:d]
      def chain_fetch(*keys, &block)
        ::Hash::ChainFetcher.new(self, *keys, &block).fetch
      end
    end
  end
end

class Hash
  include Darthjee::CoreExt::Hash
end
