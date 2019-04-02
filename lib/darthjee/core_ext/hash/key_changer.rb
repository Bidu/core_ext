# frozen_string_literal: true

module Darthjee
  module CoreExt
    module Hash
      # @api private
      class KeyChanger
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

        # Change the keys of the given hash returning the new hash
        #
        # @return New hash after keys tranformation
        #
        # @param [::Hash] options options for transformation
        # @option options [::TrueClass,::FalseClass] recursive: flag defining
        #   the change to happen also
        #   on inner hashes (defaults to: true)
        #
        # @example (see Hash#change_keys)
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
        # @return [::Hash] the given hash with it's keys changed
        # @param [::Hash] options options
        # @option options [::TrueClass,::FalseClass]
        #   uppercase_first_letter: flag
        #   defining the type of CamelCase
        #
        # @example (see Hash#camelize_keys)
        def camelize_keys(options = {})
          options = {
            uppercase_first_letter: true
          }.merge!(options)

          type = options[:uppercase_first_letter] ? :upper : :lower

          change_keys(options) do |k|
            k.camelize(type)
          end
        end

        def underscore_keys(options = {})
          change_keys(options, &:underscore)
        end

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
