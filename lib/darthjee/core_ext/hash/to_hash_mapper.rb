# frozen_string_literal: true

module Darthjee
  module CoreExt
    module Hash
      class ToHashMapper
        def initialize(hash)
          @hash = hash
        end

        def map
          {}.tap do |new_hash|
            hash.each do |k, v|
              new_hash[k] = yield(k, v)
            end
          end
        end

        private

        attr_reader :hash
      end
    end
  end
end
