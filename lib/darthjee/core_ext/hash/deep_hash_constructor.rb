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
      # @example General Usage
      #   hash = {
      #     'person.name'   => 'John',
      #     'person.age'    =>  20,
      #     :'house.number' => 67,
      #     :'house.zip'    => 12345
      #   }
      #
      #   constructor = Darthjee::CoreExt::Hash::DeepHashConstructor.new('.')
      #
      #   constructor.deep_hash(hash)  # returns {
      #                                #   'person' => {
      #                                #     'name'   => 'John',
      #                                #     'age'    =>  20
      #                                #   },
      #                                #   'house' => {
      #                                #     'number' => 67,
      #                                #     'zip'    => 12345
      #                                #   }
      #                                # }
      class DeepHashConstructor
        attr_accessor :separator

        # @param separator [::String] keys splitter
        def initialize(separator)
          @separator = separator
        end

        # Performs deep hash transformation
        #
        # @overload deep_hash(array)
        #   @param array [::Array]
        #
        #   Performs deep_hash transformation on each
        #   element that is a Hash
        #
        #   @return [::Array]
        #
        # @overload deep_hash(hash)
        #   @param array [::Hash]
        #
        #   @return [::Hash]
        #
        # @example (see DeepHashConstructor)
        def deep_hash(object)
          if object.is_a? Array
            array_deep_hash(object)
          elsif object.is_a? Hash
            hash_deep_hash(object)
          else
            object
          end
        end

        private

        # @private
        #
        # Map array performing deep hash on its Hash elements
        #
        # @param array [::Array] array to be mapped
        #
        # @return [::Array]
        def array_deep_hash(array)
          array.map do |value|
            value.is_a?(Hash) ? deep_hash(value) : value
          end
        end

        # @private
        #
        # Map Hash to new deep hashed Hash
        #
        # @param hash [::Hash]
        #
        # @return [::Hash]
        def hash_deep_hash(hash)
          {}.tap do |new_hash|
            hash.each do |k, v|
              base_key, child_key = split_key(k, separator)
              set_deep_hash_positioned_value(new_hash, base_key, v, child_key)
            end

            new_hash.each do |k, v|
              new_hash[k] = deep_hash(v)
            end
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
          separator_rxp = separator == '.' ? "\\#{separator}" : separator
          skipper = "[^#{separator}]"
          regexp = Regexp.new("^(#{skipper}*)#{separator_rxp}(.*)")
          match = key.match(regexp)

          match ? match[1..2] : key
        end

        def set_deep_hash_array_value(hash, base_key, index, value, key = nil)
          key_without_index = base_key.gsub("[#{index}]", '')
          hash[key_without_index] ||= []

          if key.nil?
            hash[key_without_index][index] = value
          else
            hash[key_without_index][index] ||= {}
            hash[key_without_index][index][key] = value
          end
        end

        def set_deep_hash_positioned_value(new_hash, base_key, value, child_key)
          index = array_index(base_key)

          if index
            set_deep_hash_array_value(
              new_hash, base_key, index,
              value, child_key
            )
          else
            set_deep_hash_value(new_hash, base_key, value, child_key)
          end
        end

        def array_index(key)
          match = key.match(/\[([^)]+)\]/)
          match && match[1].to_i
        end

        def set_deep_hash_value(hash, base_key, value, key = nil)
          if key.nil?
            hash[base_key] = value
          else
            hash[base_key] ||= {}
            hash[base_key][key] = value
          end
        end
      end
    end
  end
end
