# frozen_string_literal: true

module Darthjee
  module CoreExt
    module Hash
      # @api private
      # @author darthjee
      #
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
      #   (see #initialize)
      #
      # @example
      #   (see #change)
      class ValueChanger
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
          if object.is_a?(Hash)
            change_hash(object)
          elsif object.is_a?(Array)
            change_array(object)
          elsif iterable?(object)
            change_iterator(object)
          else
            new_value(object)
          end
        end

        private

        attr_reader :recursive, :skip_inner, :block

        # @private
        #
        # Apply change logic to hash object
        #
        # @param hash [::Hash] hash to be changed
        #
        # @return [::Hash]
        def change_hash(hash)
          hash.tap do
            hash.each do |key, value|
              hash[key] = new_value(value)
            end
          end
        end

        # @private
        #
        # Apply change logic to iterator
        #
        # @param array [::Array] array to be changed
        #
        # @return [::Array]
        def change_array(array)
          array.map!(&method(:change))
        end

        def change_iterator(array)
          array.map(&method(:change))
        end

        # @private
        #
        # Check wehether block should be called over value
        #
        # when the block is not iterable (not Array or Hash)
        # or when skip_inner option is set to be false,
        # then block should be called
        #
        # @param value [::Object] value to be checked
        #
        # @return [::TrueClass,::FalseClass]
        def change_value?(value)
          !iterable?(value) || !skip_inner
        end

        # @private
        #
        # Checks if a value is iterable
        #
        # @param value [::Object] object to be checked
        #
        # @return [::TrueClass,::FalseClass]
        def iterable?(value)
          value.respond_to?(:each)
        end

        # @private
        #
        # Performs recursive transformation
        #
        # @overload new_value(hash)
        #   @param hash [::Hash] sub-hash to be processed recursively
        #   @return [::Hash]
        #
        # @overload new_value(array)
        #   @param array [::Array] array to be processed recursively
        #   @return [::Array]
        #
        # @overload new_value(value)
        #   @param value [::Object] value to be transformed
        #
        # @return [::Object]
        def new_value(value)
          value = block.call(value) if change_value?(value)

          return value unless apply_recursion?(value)

          change(value)
        end

        # @private
        #
        # Checks if recursion should be applied
        #
        # @param value [::Object]
        #
        # @return [::TrueClass,::FalseClass]
        def apply_recursion?(value)
          iterable?(value) && recursive
        end
      end
    end
  end
end
