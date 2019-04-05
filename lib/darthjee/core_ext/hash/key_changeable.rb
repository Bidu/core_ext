# frozen_string_literal: true

module Darthjee
  module CoreExt
    module Hash
      # Module holding methods responsible for
      # changing / transforming keys of a Hash
      #
      # @api public
      #
      # @author Darthjee
      #
      # @see KeyChanger
      # @see KeysSorter
      module KeyChangeable
        ##########################################
        # Key change methods
        ##########################################

        # Change all keys without changing the original hash
        #
        # It changes all keysby publically sending methods
        # to the keys
        #
        # @return [::Hash] New hash with the resulting keys
        # @param [::Array<Symbol>] calls methods to be
        #   called form the key`
        #
        # @see #chain_change_keys!
        #
        # @example
        #   hash = { first: 1, second: 2 }
        #   resut = hash.chain_change_keys(:to_s, :size, :to_s, :to_sym)
        #   result     # returns { :'5' => 1, :'6' => 2 }
        def chain_change_keys(*calls)
          deep_dup.chain_change_keys!(*calls)
        end

        # Change all keys changing the original hash
        #
        # It changes all keys by publically sending methods
        # to the keys
        #
        # @return [::Hash] New hash with the resulting keys
        # @param [::Array<Symbol>] calls methods to be called form the key`
        #
        # @see #change_keys
        #
        # @example (see #chain_change_keys)
        def chain_change_keys!(*calls)
          options = calls.extract_options!

          calls.inject(self) do |h, m|
            h.change_keys!(options, &m)
          end
        end

        # Change all keys returning the new hash
        #
        # @return new Hash with modified keys
        # @param [::Hash] options options to passed to KeyChanger
        # @option options [::TrueClass,::FalseClass]
        #   recursive (true) flag defining the
        #   change to happen also
        #   on inner hashes (defaults to: true)
        #
        # @yield (key) changing key block
        #
        # @see Hash::KeyChanger#change_keys
        #
        # @example
        #   hash = { '1' => 1, '2' => { '3' => 2} }
        #
        #   result = hash.change_keys do |k|
        #     (k.to_i + 1).to_s.to_sym
        #   end
        #   result   # returns { :'2' => 1, :'3' => { :'4' => 2 } }
        #
        #   result = hash.change_keys(recursive:false) do |k|
        #     (k.to_i + 1).to_s.to_sym
        #   end
        #   result    # returns { :'2' => 1, :'3' => { '3' => 2 } }
        def change_keys(options = {}, &block)
          deep_dup.change_keys!(options, &block)
        end

        # Change all keys modifying and returning the hash
        #
        # @return self
        # @param [::Hash] options options to passed to KeyChanger
        # @option options [::TrueClass,::FalseClass]
        #   recursive: (true) flag defining the
        #   change to happen also
        #   on inner hashes (defaults to: true)
        #
        # @yield (key) changing key block
        #
        # @see Hash::KeyChanger#change_keys
        #
        # @example (see #change_keys)
        def change_keys!(options = {}, &block)
          Hash::KeyChanger.new(self).change_keys(options, &block)
        end

        # prepend a string to all keys
        #
        # @param options [::Hash]
        # @option options [::TrueClass,::FalseClass]
        #   recursive (true)
        #   flag indicating transformation should be recursive
        # @option options [::Symbol] type (:keep)
        #   type of the final key
        #   - keep : cast the result to the same type of the
        #     original key
        #   - string : cast the result to be {::String}
        #   - symbol cast the result to be {::Symbol}
        #
        # @return [::Hash]
        #
        # @see KeyChanger#change_keys
        #
        # @example
        #   hash = { :a => 1, "b"=> 2 }
        #
        #   hash.prepend_to_keys("foo_") # returns {
        #                                #   :foo_a => 1,
        #                                #   "foo_b"=> 2
        #                                # }
        def prepend_to_keys(str, options = {})
          change_key_text(options) do |key|
            "#{str}#{key}"
          end
        end

        # Append a string to all keys
        #
        # @param options [::Hash]
        # @option options [::TrueClass,::FalseClass]
        #   recursive (true)
        #   flag indicating transformation should be recursive
        # @option options [::Symbol] type (:keep)
        #   type of the final key
        #   - keep : cast the result to the same type of the
        #     original key
        #   - string : cast the result to be {::String}
        #   - symbol cast the result to be {::Symbol}
        #
        # @return [::Hash]
        #
        # @see KeyChanger#change_keys
        #
        # @example (see #prepend_to_keys)
        def append_to_keys(str, options = {})
          change_key_text(options) do |key|
            "#{key}#{str}"
          end
        end

        # Sorts keys for hash without changing the original
        #
        # @param options [::Hash]
        # @option options [::TrueClass,::FalseClass]
        #   recursive (true) flag indicating recursive sorting
        #
        # @return [::Hash]
        #
        # @see KeySorter#sort
        #
        # @example
        #   hash = { b: 1, a: 2 }
        #
        #   hash.sort_keys  # returns { a: 2, b: 1 }
        def sort_keys(options = {})
          Hash::KeysSorter.new(self, **options).sort
        end

        ##########################################
        # Value change methods
        ##########################################

        # Creates a new hash with changes in its values
        #
        # @param options [::Hash]
        # @option options [::TrueClass,::FalseClass]
        #   recursive (true) flag indicating recursive sorting
        # @option options [::TrueClass,::FalseClass]
        #   skip_inner (true) Flag indicating to skip running
        #   transformation on Hash objects
        #
        # @yield (value) changing value block
        #
        # @return [::Hash]
        #
        # @example Simple Usage
        #   hash = { a: 1, b: 2 }
        #   hash.change_values do |value|
        #     value + 1
        #   end                     # returns { a: 2, b: 3 }
        #
        # @example Skipping inner hash transformation
        #   hash = { a: 1, b: { c: 1 } }
        #
        #   hash.change_values(&:to_s)) # returns {
        #                               #   a: "1",
        #                               #   b: { c: "1" }
        #                               # }
        #
        # @example Not skipping inner hash transformation
        #   hash = { a: 1, b: { c: 1 } }
        #
        #   hash.change_values(skip_inner: false, &:to_s))
        #                               # returns {
        #                               #   a: "1",
        #                               #   b: "{:c=>1}"
        #                               # }
        def change_values(options = {}, &block)
          deep_dup.change_values!(options, &block)
        end

        # Changes the values of a hash
        #
        # @param options [::Hash]
        # @option options [::TrueClass,::FalseClass]
        #   recursive (true) flag indicating recursive sorting
        # @option options [::TrueClass,::FalseClass]
        #   skip_inner (true) Flag indicating to skip running
        #   transformation on Hash objects
        #
        # @yield (value) changing value block
        #
        # @return [::Hash]
        #
        # @example (see change_values)
        #
        # @example Changing inner hash
        #   inner_hash = { c: 2 }
        #   hash = { a: 1, b: inner_hash }
        #
        #   hash.change_values!(&:to_s)
        #
        #   inner_hash # changed to { c: "2" }
        #
        # @example Not changing inner hash
        #   inner_hash = { c: 2 }
        #   hash = { a: 1, b: inner_hash }
        #
        #   hash.change_values!(skip_inner: false, &:to_s)
        #
        #   hash       # changed to { a: "1", b: "{:c=>2}" }
        #   inner_hash # still      { c: 2 }
        def change_values!(options = {}, &block)
          Hash::ValueChanger.new(options, &block).change(self)
        end

        # Changes the key of the hash without changing it
        #
        # @return [::Hash] new hash
        #
        # @example
        #   hash = { a: 1, b: 2 }
        #   hash.remap_keys(a: :b, b: :c) # returns {
        #                                 #   b: 1,
        #                                 #   c: 2
        #                                 # }
        def remap_keys(remap)
          dup.remap_keys!(remap)
        end

        # Changes the key of the hash changing the original
        #
        # @return [::Hash] self
        #
        # @example (see #remap_keys)
        def remap_keys!(keys_map)
          KeyChanger.new(self).remap(keys_map)
        end

        private

        # @private
        # @api private
        #
        # Changes the text of the keys
        #
        # @param options [::Hash]
        # @option options [::TrueClass,::FalseClass]
        #   recursive (true)
        #   flag indicating transformation should be recursive
        # @option options [::Symbol] type (:keep)
        #   type of the final key
        #   - keep : cast the result to the same type of the
        #     original key
        #   - string : cast the result to be {::String}
        #   - symbol cast the result to be {::Symbol}
        #
        # @yield (key) changing key block
        #
        # @return [::Hash]
        #
        # @see KeyChanger
        def change_key_text(options = {}, &block)
          Hash::KeyChanger.new(self).change_text(options, &block)
        end
      end
    end
  end
end
