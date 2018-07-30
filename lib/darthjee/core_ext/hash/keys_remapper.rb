# frozen_string_literal: true

class Hash
  class KeysRemapper
    def initialize(hash)
      @hash = hash
    end

    def remap(keys_map)
      new_hash = {}
      keys_map.each do |o, n|
        new_hash[n] = hash.delete(o)
      end
      hash.merge! new_hash
    end

    private

    attr_reader :hash
  end
end
