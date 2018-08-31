# frozen_string_literal: true

module Darthjee
  module CoreExt
    module Hash
      class ChainFetcher
        def initialize(hash, *keys, &block)
          @hash = hash
          @keys = keys
          @block = block
        end

        def fetch
          block.present? ? fetch_with_block : fetch_without_block
        end

        private

        attr_reader :hash, :keys, :block

        def fetch_with_block
          @hash = hash.fetch(keys.shift) do |*args|
            missed_keys = keys
            @keys = []
            block.call(*(args + [missed_keys]))
          end until keys.empty?
          hash
        end

        def fetch_without_block
          @hash = hash.fetch(keys.shift) until keys.empty?
          hash
        end
      end
    end
  end
end
