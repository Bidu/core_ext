# frozen_string_literal: true

class Hash
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
