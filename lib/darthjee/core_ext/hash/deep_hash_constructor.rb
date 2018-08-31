# frozen_string_literal: true

module Darthjee
  module CoreExt
    module Hash
      class DeepHashConstructor
        attr_accessor :separator

        def initialize(separator)
          @separator = separator
        end

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

        def array_deep_hash(array)
          array.map { |v| v.is_a?(Hash) ? deep_hash(v) : v }
        end

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
            set_deep_hash_array_value(new_hash, base_key, index, value, child_key)
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
