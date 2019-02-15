# frozen_string_literal: true

module Darthjee
  module CoreExt
    module Hash
      class ValueChanger
        attr_accessor :recursive, :skip_inner, :block

        def initialize(recursive: true, skip_inner: true, &block)
          @recursive = recursive
          @skip_inner = skip_inner

          @block = block
        end

        def change(object)
          if object.respond_to?(:change_values)
            change_hash(object)
          elsif iterable?(object)
            change_array(object)
          else
            object
          end
        end

        private

        def change_hash(original_hash)
          original_hash.tap do |hash|
            original_hash.each do |key, value|
              value = new_value(value)
              hash[key] = value
            end
          end
        end

        def change_array(array)
          method = %w[map! map].find { |m| array.respond_to? m }

          array.public_send(method) do |value|
            if value.respond_to?(:change_values)
              value.change_values(options, &block)
            elsif iterable?(value)
              change_array(value)
            else
              new_value(value)
            end
          end
        end

        def change_value?(value)
          !iterable?(value) || !skip_inner
        end

        def iterable?(value)
          value.respond_to?(:each)
        end

        def new_value(value)
          value = block.call(value) if change_value?(value)
          apply_recursion?(value) ? change(value) : value
        end

        def apply_recursion?(value)
          iterable?(value) && recursive
        end

        def options
          @options ||= {
            recursive: recursive,
            skip_inner: skip_inner
          }
        end
      end
    end
  end
end
