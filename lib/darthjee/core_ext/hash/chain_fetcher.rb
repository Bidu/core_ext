# frozen_string_literal: true

module Darthjee
  module CoreExt
    module Hash
      # Class responsible for running ::Hash#chain_fetch
      #
      # @api private
      #
      # @author Darthjee
      #
      # @see Darthjee::CoreExt::Hash#chain_fetch
      class ChainFetcher
        def initialize(hash, *keys, &block)
          @hash = hash
          @keys = keys
          @block = block
        end

        # Crawls through the hash fetching the keys in chain
        #
        # @example (see Darthjee::CoreExt::Hash#chain_fetch)
        #
        # @return [Object] value fetched from array
        def fetch
          return fetch_with_block if block.present?
          fetch_without_block
        end

        private

        # @private
        attr_reader :hash, :keys, :block

        # @private
        #
        # Perform chain fetch when block is given
        #
        # The block will be called in case a key is missed
        #
        # @return [Object]
        def fetch_with_block
          @hash = hash.fetch(keys.shift) do |*args|
            missed_keys = keys
            @keys = []
            block.call(*(args + [missed_keys]))
          end until keys.empty?
          hash
        end

        # @private
        #
        # Perform chain fetch when block is not given
        #
        # @return [Object]
        def fetch_without_block
          @hash = hash.fetch(keys.shift) until keys.empty?
          hash
        end
      end
    end
  end
end
