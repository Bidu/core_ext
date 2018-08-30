# frozen_string_literal: true

class Hash
  module Transformable
    def squash
      Squasher.squash(self)
    end

    def to_deep_hash(separator = '.')
      Hash::DeepHashConstructor.new(separator).deep_hash(self)
    end

    def map_to_hash(&block)
      ToHashMapper.new(self).map(&block)
    end

    def exclusive_merge(hash)
      dup.exclusive_merge!(hash)
    end

    def exclusive_merge!(hash)
      merge!(hash.slice(*keys))
    end
  end
end
