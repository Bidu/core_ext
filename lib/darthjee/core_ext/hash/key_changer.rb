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
        # @param [::Hash] options options for transformation
        # @option options [::TrueClass,::FalseClass]
        #   recursive (true) flag defining
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
        def change_keys(options = {}, &block)
          options = {
            recursive: true
          }.merge!(options)

          if options[:recursive]
            hash.deep_transform_keys!(&block)
          else
            hash.transform_keys!(&block)
          end
        end

        # Performs camelization of the keys of the hash
        #
        # @param [::Hash] options
        # @option options [::TrueClass,::FalseClass]
        #   uppercase_first_letter (true) flag
        #   defining the type of CamelCase
        # @option options [::TrueClass,::FalseClass]
        #   recursive (true) flag defining
        #   the change to happen also on inner hashes
        #
        # @return [::Hash] the given hash with it's keys
        #   changed
        #
        # @example (see Cameliazable#camelize_keys)
        #
        # @example
        #   hash = { my_key: { inner_key: 10 } }
        #   changer = Darthjee::CoreExt::Hash::KeyChanger.new(hash)
        #   changer.camelize_keys
        #   hash   # changed to { MyKey: { InnerKey: 10 } }
        def camelize_keys(options = {})
          options = {
            uppercase_first_letter: true
          }.merge!(options)

          type = options[:uppercase_first_letter] ? :upper : :lower

          change_keys(options) do |k|
            k.camelize(type)
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
        #
        # @option options [::TrueClass,::FalseClass]
        #   recursive (true) flag defining
        #   the change to happen also on inner hashes
        #
        # @yield (key) key transformation block
        #
        # @example
        #   hash = { key: { inner_key: 10 } }
        #   changer = Darthjee::CoreExt::Hash::KeyChanger.new(hash)
        #   changer.change_text { |key| key.to_s.upcase }
        #
        #   hash  # changed to { KEY: { INNER_KEY: 10 } }
        def change_text(options = {})
          options = {
            type: :keep
          }.merge!(options)

          change_keys(options) do |key|
            cast_new_key yield(key), key.class, options
          end
        end

        private

        attr_reader :hash

        def cast_new_key(key, old_clazz, options)
          case class_cast(old_clazz, options)
          when :symbol then
            key.to_sym
          when :string then
            key.to_s
          end
        end

        def keep_class?(options)
          options[:type] == :keep
        end

        def class_cast(old_clazz, options)
          klass = keep_class?(options) && old_clazz.to_s.downcase.to_sym
          klass || options[:type]
        end
      end
    end
  end
end
