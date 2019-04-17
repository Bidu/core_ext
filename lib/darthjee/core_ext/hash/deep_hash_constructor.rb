# frozen_string_literal: true

module Darthjee
  module CoreExt
    module Hash
      # @api private
      #
      # @author Darthjee
      #
      # Class responsible for creating a Hash deep hash
      #
      # Deep hash construction happens when a hash of one layer
      # (no sub hashes) has keys that, once explitted, can be
      # assembled in a hash with many layers
      #
      # @see Transformable#squash
      # @see Transformable#to_deep_hash
      #
      # @example (see Transformable#to_deep_hash)
      # @example General Usage
      #   hash = {
      #     'account.person.name[0]' => 'John',
      #     'account.person.name[1]' => 'Wick',
      #     'account.person.age'     =>  20,
      #     'account.number'         => '102030',
      #     :'house.number'          => 67,
      #     :'house.zip'             => 12_345
      #   }
      #
      #   constructor = Darthjee::CoreExt::Hash::DeepHashConstructor.new('.')
      #
      #   constructor.deep_hash(hash)  # returns {
      #                                #   'account' => {
      #                                #     'person' => {
      #                                #       'name'   => ['John', 'Wick'],
      #                                #       'age'    =>  20
      #                                #     },
      #                                #     'number' => '102030',
      #                                #   },
      #                                #   'house' => {
      #                                #     'number' => 67,
      #                                #     'zip'    => 12345
      #                                #   }
      #                                # }
      class DeepHashConstructor
        autoload :Setter, "#{PATH}/hash/deep_hash_constructor/setter"

        # @param separator [::String] keys splitter
        def initialize(separator = '.')
          @separator = separator
        end

        # Performs deep hash transformation
        #
        # @param hash [::Hash] On layered hash
        #
        # @return [::Hash] Many layered hash
        #
        # @example (see DeepHashConstructor)
        def deep_hash(hash)
          break_keys(hash).tap do
            hash.each do |key, value|
              hash[key] = deep_hash_value(value)
            end
          end
        end

        private

        # @private
        attr_reader :separator

        # @private
        # break the keys creating sub-hashes
        #
        # @param hash [::Hash] hash to be broken
        #
        # @example Breaking many level keys
        #   hash = {
        #     'account.person.name[0]' => 'John',
        #     'account.person.name[1]' => 'Wick',
        #     'account.person.age'     =>  20,
        #     'account.number'         => '102030',
        #     :'house.number'          => 67,
        #     :'house.zip'             => 12_345
        #   }
        #
        #   constructor = Darthjee::CoreExt::Hash::DeepHashConstructor.new('.')
        #
        #   constructor.send(:break_keys, hash)
        #
        #   # Returns {
        #   #   'account' => {
        #   #     %w[person name[0]] => 'John',
        #   #     %w[person name[1]] => 'Wick',
        #   #     %w[person age]     =>  20,
        #   #     %w[number]         => '102030'
        #   #   },
        #   #   'house' => {
        #   #     %w[number] => 67,
        #   #     %w[zip]    => 12_345
        #   #   }
        #   # }
        #
        # @return [Hash]
        def break_keys(hash)
          hash.keys.each do |key|
            value = hash.delete(key)
            base_key, child_key = split_key(key, separator)
            Setter.new(hash, base_key).set(child_key, value)
          end

          hash
        end

        # @private
        #
        # Recursively proccess a value calling deep hash on it
        #
        # @return [::Object]
        def deep_hash_value(object)
          return array_deep_hash(object) if object.is_a? Array
          return deep_hash(object) if object.is_a? Hash
          object
        end

        # @private
        #
        # Map array performing deep hash on its Hash elements
        #
        # @param array [::Array] array to be mapped
        #
        # @return [::Array]
        def array_deep_hash(array)
          array.map do |value|
            deep_hash_value(value)
          end
        end

        # @private
        #
        # Split key into array of keys
        #
        # @param key [::String,::Symbol] key to be splitted
        # @param separator [::String] string of key splitting
        #
        # @return [::Array<::String>,::String]
        def split_key(key, separator)
          keys = key.is_a?(Array) ? key : key.to_s.split(separator)

          return keys.first unless keys.second

          [keys.first, keys[1..-1]]
        end
      end
    end
  end
end
