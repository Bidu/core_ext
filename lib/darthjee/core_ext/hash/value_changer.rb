# frozen_string_literal: true

module Darthjee
  module CoreExt
    module Hash
      # Class responsible for changing values on a hash
      #
      # @attribute [::TrueClass,::FalseClass] recursive
      #   flag telling to apply transformation recursively
      # @attribute [::TrueClass,::FalseClass] skip_inner
      #   flag telling to not apply change block call to inner hashes
      # @attribute [::Proc] block
      #   block to be called when changing the values
      #
      # @example
      #   (see initialize)
      #
      # @example
      #   (see #change)
      class ValueChanger
        attr_accessor :recursive, :skip_inner, :block

        # @param [::TrueClass,::FalseClass] recursive
        #   flag telling to apply transformation recursively
        # @param [::TrueClass,::FalseClass] skip_inner
        #   flag telling to not apply change block call to inner hashes
        # @param [::Proc] block
        #   block to be called when changing the values
        #
        #
        # @example
        #   changer = Darthjee::CoreExt::Hash::ValueChanger.new(
        #     recursive: false,
        #     skip_inner: false,
        #     &:class
        #   )
        #
        #   hash = { a: 1, b: { c: 2 }, d: [{ e: 1 }] }
        #   changer.change(hash)  # {
        #                         #   a: Integer,
        #                         #   b: Hash,
        #                         #   d: Array
        #                         # }
        def initialize(recursive: true, skip_inner: true, &block)
          @recursive = recursive
          @skip_inner = skip_inner

          @block = block
        end

        # Change the given object
        #
        # @return the resulting object (hash or array)
        #   with it`s values changed
        # @param [::Hash/::Array] object
        #   object to have it's values changed
        #
        # @example
        #   changer = Darthjee::CoreExt::Hash::ValueChanger.new do |value|
        #     value.to_s.size
        #   end
        #
        #   hash = { a: 15, b: { c: 2 }, d: [{ e: 100 }] }
        #   changer.change(hash)  # {
        #                         #   a: 2,
        #                         #   b: { c: 1 },
        #                         #   d: [{ e: 3 }]
        #                         # }
        #
        # @example
        #   changer = Darthjee::CoreExt::Hash::ValueChanger.new(
        #     skip_inner: true
        #   ) do |value|
        #     value.to_s.size
        #   end
        #
        #   hash = { a: 15, b: { c: 2 }, d: [{ e: 100 }] }
        #   changer.change(hash)  # {
        #                         #   a: 2,
        #                         #   b: 11,
        #                         #   d: 7
        #                         # }
        #
        # @example
        #   changer = Darthjee::CoreExt::Hash::ValueChanger.new(
        #     recursive: true
        #   ) do |value|
        #     value.to_s.size
        #   end
        #
        #   hash = { a: 15, b: { c: 2 }, d: [{ e: 100 }] }
        #   changer.change(hash)  # {
        #                         #   a: 2,
        #                         #   b: { c: 1 },
        #                         #   d: [{ e: 3 }]
        #                         # }
        #
        # @example
        #   changer = Darthjee::CoreExt::Hash::ValueChanger.new do |value|
        #     value.to_s.size
        #   end
        #
        #   array = [15, { c: 2 }, [{ e: 100 }]]
        #
        #   changer.change(array) # [
        #                         #   2,
        #                         #   { c: 1 },
        #                         #   [{ e: 3 }]
        #                         # ]
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

        # Apply change logic to hash object
        #
        # @private
        def change_hash(original_hash)
          original_hash.tap do |hash|
            original_hash.each do |key, value|
              hash[key] = new_value(value)
            end
          end
        end

        # Apply change logic to iterator
        #
        # @private
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

        # check wehether block should be called over
        # value or not
        #
        # when the block is not iterable (not Array or Hash)
        # or when skip_inner option is set to be false,
        # then block should be called
        #
        # @private
        def change_value?(value)
          !iterable?(value) || !skip_inner
        end

        def iterable?(value)
          value.respond_to?(:each)
        end

        def new_value(value)
          value = block.call(value) if change_value?(value)

          return value unless apply_recursion?(value)

          change(value)
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
