# frozen_string_literal: true

module Darthjee
  module CoreExt
    module Hash
      module Transformable
        def squash
          Darthjee::CoreExt::Hash::Squasher.squash(self)
        end

        def to_deep_hash(separator = '.')
          Darthjee::CoreExt::Hash::DeepHashConstructor.new(separator).deep_hash(self)
        end

        def map_to_hash(&block)
          Darthjee::CoreExt::Hash::ToHashMapper.new(self).map(&block)
        end

        def exclusive_merge(hash)
          dup.exclusive_merge!(hash)
        end

        def exclusive_merge!(hash)
          merge!(hash.slice(*keys))
        end
      end
    end
  end
end
