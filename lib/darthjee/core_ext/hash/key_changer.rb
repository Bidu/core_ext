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
        # @param [::Hash] settings options for transformation
        # @option settings [Boolean] recursive: flag defining
        #   the change to happen also
        #   on inner hashes (defaults to: true)
        #
        # @example (see Hash#change_keys)
        def change_keys(settings = {}, &block)
          merge_options({
                          recursive: true
                        }, settings)

          if options[:recursive]
            hash.deep_transform_keys!(&block)
          else
            hash.transform_keys!(&block)
          end
        end

        def camelize_keys(settings = {})
          merge_options({
                          uppercase_first_letter: true
                        }, settings)

          type = options[:uppercase_first_letter] ? :upper : :lower

          change_keys do |k|
            k.camelize(type)
          end
        end

        def underscore_keys(settings = {})
          merge_options({}, settings)

          change_keys(&:underscore)
        end

        def change_text(options = {})
          merge_options({
                          type: :keep
                        }, options)

          change_keys do |key|
            cast_new_key yield(key), key.class
          end
        end

        private

        attr_reader :hash

        def merge_options(default, custom)
          @options = {}.merge!(default).merge!(custom).merge!(options)
        end

        def options
          @options ||= {}
        end

        def cast_new_key(key, old_clazz)
          case class_cast(old_clazz)
          when :symbol then
            key.to_sym
          when :string then
            key.to_s
          end
        end

        def keep_class?
          options[:type] == :keep
        end

        def class_cast(old_clazz)
          keep_class? && old_clazz.to_s.downcase.to_sym || options[:type]
        end
      end
    end
  end
end
