# frozen_string_literal: true

module Darthjee
  module CoreExt
    module Hash
      # @api private
      #
      # @author Darthjee
      class KeyChanger
        def initialize(hash)
          @hash = hash
        end

        # Changes keys based on map
        #
        # @param keys_map [::Hash] map of
        #   original => final  key
        #
        # @return [::Hash] the given hash modified
        #
        # @example
        #   hash = { a: 1, 'b' => 2 }
        #   changer = Darthjee::CoreExt::Hash::KeyChanger.new(hash)
        #   remap_map = { a: 1, 'b' => 2 }
        #
        #   changer.remap(remap_map)
        #
        #   hash   # changed to {
        #          #   za: 1,
        #          #   'yb' => 2,
        #          #   zb: nil
        #          # }
        #
        # @example (see Hash::KeyChangeable#remap_keys)
        def remap(keys_map)
          new_hash = {}
          keys_map.each do |o, n|
            new_hash[n] = hash.delete(o)
          end
          hash.merge! new_hash
        end

        # Change the keys of the given hash returning the new hash
        #
        # @param [::TrueClass,::FalseClass]
        #   recursive flag defining
        #   the change to happen also on inner hashes
        #
        # @return [::Hash] Given hash after keys tranformation
        #
        # @example (see Hash::KeyChangeable#change_keys)
        #
        # @example
        #   hash = { a: 1, 'b' => { c: 3 } }
        #   changer = Darthjee::CoreExt::Hash::KeyChanger.new(hash)
        #   changer.change_keys { |k| "key_#{k}" }
        #
        #   hash # changed to {
        #        #   'key_a' => 1,
        #        #   'key_b' => {
        #        #     'key_c' => 3
        #        #   }
        #        # }
        def change_keys(recursive: true, &block)
          if recursive
            hash.deep_transform_keys!(&block)
          else
            hash.transform_keys!(&block)
          end
        end

        # Performs camelization of the keys of the hash
        #
        # @param [::Hash] options
        # @param [::TrueClass,::FalseClass]
        #   uppercase_first_letter flag
        #   defining the type of CamelCase
        # @option options [::TrueClass,::FalseClass]
        #   recursive (true) flag defining
        #   the change to happen also on inner hashes
        #
        # @return [::Hash] the given hash with it's keys
        #   changed
        #
        # @see #change_keys
        # @see Cameliazable#camelize_keys
        #
        # @example (see Cameliazable#camelize_keys)
        #
        # @example
        #   hash = { my_key: { inner_key: 10 } }
        #   changer = Darthjee::CoreExt::Hash::KeyChanger.new(hash)
        #   changer.camelize_keys
        #   hash   # changed to { MyKey: { InnerKey: 10 } }
        def camelize_keys(uppercase_first_letter: true, **options)
          type = uppercase_first_letter ? :upper : :lower

          change_keys(options) do |key|
            key.camelize(type)
          end
        end

        # Changes keys by performing underscore transformation
        #
        # @param [::hash] options
        # @option options [::TrueClass,::FalseClass]
        #   recursive (true) flag defining
        #   the change to happen also on inner hashes
        #
        # @return [::Hash]
        #
        # @example (see Cameliazable#underscore_keys)
        #
        # @example
        #   hash = { myKey: { InnerKey: 10 } }
        #   changer = Darthjee::CoreExt::Hash::KeyChanger.new(hash)
        #   changer.underscore_keys
        #
        #   hash  # changed to { my_key: { inner_key: 10 } }
        def underscore_keys(options = {})
          change_keys(options, &:underscore)
        end

        # Change keys considering them to be strings
        #
        # @param options [::Hash]
        # @param type [::Symbol] type that key will be case
        #   - keep: Cast the key back to the same type it was
        #   - string cast the key to {String}
        #   - symbol cast the key to {Symbol}
        #
        # @option options [::TrueClass,::FalseClass]
        #   recursive (true) flag defining
        #   the change to happen also on inner hashes
        #
        # @yield (key) key transformation block
        #
        # @return [::Hash] the given hash with changed keys
        #
        # @example
        #   hash = { key: { inner_key: 10 } }
        #   changer = Darthjee::CoreExt::Hash::KeyChanger.new(hash)
        #   changer.change_text { |key| key.to_s.upcase }
        #
        #   hash  # changed to { KEY: { INNER_KEY: 10 } }
        def change_text(type: :keep, **options)
          change_keys(**options) do |key|
            cast_new_key yield(key), key.class, type
          end
        end

        private

        attr_reader :hash

        # @api private
        # @private
        #
        # Cast key to correct type (String or Symbol)
        #
        # @param key [::String] key to be cast
        #   (after transformation)
        # @param old_clazz [::Class] original class of the key
        # @param type [::Symbol] option of type
        #   - keep: Cast the key back to the same type it was
        #   - string cast the key to {String}
        #   - symbol cast the key to {Symbol}
        #
        # @return [::String,::Symbol]
        def cast_new_key(key, old_clazz, type)
          case class_cast(old_clazz, type)
          when :symbol then
            key.to_sym
          when :string then
            key.to_s
          end
        end

        # @api private
        # @private
        #
        # Returns the type of the cast to be applied
        #
        # @param old_clazz [::Class] original class of a key
        # @param type [:symbol] option of castying
        #   - keep: Cast the key back to the same type it was
        #   - string cast the key to {String}
        #   - symbol cast the key to {Symbol}
        #
        # @see #cast_new_key
        #
        # @return [::Symbol]
        def class_cast(old_clazz, type)
          return type unless type == :keep
          old_clazz.to_s.downcase.to_sym
        end
      end
    end
  end
end
