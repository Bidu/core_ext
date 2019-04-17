# frozen_string_literal: true

module Darthjee
  module CoreExt
    module Hash
      class DeepHashConstructor
        # @api private
        #
        # Class responsible for setting value localized inside hash
        #
        # @example Simple usage
        #   hash   = {}
        #   base   = 'person'
        #   setter = Darthjee::CoreExt::Hash::DeepHashConstructor::Setter.new(
        #     hash, base
        #   )
        #
        #   setter.set('age', 21)
        #
        #   hash # changed to {
        #        #   'person' => {
        #        #     'age' => 21,
        #        #   }
        #        # }
        class Setter
          # @param hash [Hash] hash to be changed
          # @param base_key [::String] base key of hash where
          #   subhash will be created
          def initialize(hash, base_key)
            @hash     = hash
            @base_key = base_key
            @key      = key
          end

          # Sets a value in the correct key inside the hash
          #
          # @param key [::String,::NilClass] key where value will live
          # @param value [::Object] value to be set
          #
          # @return [::Object] value
          #
          # @example (see DeepHashConstructor)
          #
          # @example With Array index
          #   hash   = {}
          #   base   = 'person[0]'
          #   setter = Darthjee::CoreExt::Hash::DeepHashConstructor::Setter.new(
          #     hash, base
          #   )
          #
          #   setter.set('age', 21)
          #
          #   hash # changed to {
          #        #   'person' => [{
          #        #     'age' => 21,
          #        #   }]
          #        # }
          def set(key, value)
            return hash[base_key]    = value if key.nil? && index.nil?
            return array[index]      = value if key.nil?

            sub_hash[key] = value
          end

          private

          # @private
          attr_reader :hash, :base_key, :key

          # @private
          # Extract index of array from base_key
          #
          # @return [::NilClass,::Integer]
          def index
            return @index if instance_variable_defined?('@index')

            match = base_key.match(/\[([^)]+)\]/)
            return @index = nil unless match

            @index = match[1].to_i
          end

          # @private
          # Returns array that will receive value
          #
          # This array is only created / used when base_key
          # contains index
          #
          # @return [::Array]
          def array
            return @array if instance_variable_defined?('@array')

            key_without_index = base_key.tr("[#{index}]", '')

            @array = hash[key_without_index] ||= []
          end

          # @private
          # Returns sub hash that will receive the value
          #
          # This sub_hash is only build when key is not nil
          #
          # @return [::Hash]
          def sub_hash
            return array[index] ||= {} if index

            hash[base_key] ||= {}
          end
        end
      end
    end
  end
end
