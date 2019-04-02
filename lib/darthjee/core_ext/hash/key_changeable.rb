# frozen_string_literal: true

module Darthjee
  module CoreExt
    module Hash
      # Module holding methods responsible for
      # changing / transforming keys of a Hash
      #
      # @api public
      module KeyChangeable
        # Change all keys by publically sending methods to the keys without
        # changing the original hash
        #
        # @return [::Hash] New hash with the resulting keys
        # @param [::Array<Symbol>] calls methods to be called form the key`
        #
        # @see #change_keys
        #
        # @example
        #   hash = { first: 1, second: 2 }
        #   resut = hash.chain_change_keys(:to_s, :size, :to_s, :to_sym)
        #   result     # returns { :'5' => 1, :'6' => 2 }
        def chain_change_keys(*calls)
          deep_dup.chain_change_keys!(*calls)
        end

        # Change all keys by publically sending methods to the keys
        # changing the original hash
        #
        # @return [::Hash] New hash with the resulting keys
        # @param [::Array<Symbol>] calls methods to be called form the key`
        #
        # @see #chain_change_keys
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
        #   recursive: flag defining the
        #   change to happen also
        #   on inner hashes (defaults to: true)
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
        #   recursive: flag defining the
        #   change to happen also
        #   on inner hashes (defaults to: true)
        #
        # @see Hash::KeyChanger#change_keys
        #
        # @example (see #change_keys)
        def change_keys!(options = {}, &block)
          Hash::KeyChanger.new(self).change_keys(options, &block)
        end

        # prepend a string to all keys
        # options {
        #  recursive: true,
        #  type: :keep [keep, string, symbol] (key type to be returned)
        # }
        # ex: { :a => 1, "b"=> 2 }.prepend_to_keys("foo_")
        # # returns { :foo_a => 1, "foo_b"=> 2 }
        def prepend_to_keys(str, options = {})
          change_key_text(options) do |key|
            "#{str}#{key}"
          end
        end

        # append a string to all keys
        # options {
        #  recursive: true,
        #  type: :keep [keep, string, symbol] (key type to be returned)
        # }
        # ex: { :a => 1, "b"=> 2 }.append_to_keys("_bar")
        # # returns { :a_bar => 1, "b_bar"=> 2 }
        def append_to_keys(str, options = {})
          change_key_text(options) do |key|
            "#{key}#{str}"
          end
        end

        # sorts keys for hash
        # options: { recursive: true }
        # ex: { b:1, a:2 }.sort_keys == { a:2, b:1 }
        def sort_keys(options = {})
          Hash::KeysSorter.new(self, **options).sort
        end

        ##########################################
        # Value change methods
        ##########################################

        # creates a new hash with changes in its values
        # options: {
        #   recursive: true,
        #   skip_hash:true
        # }
        # ex: { a:1, b:2 }.change_values{ |v| v+1 } == { a:2, b:3 }
        # ex: { a:1, b:{ c:1 } }.change_values(skip_hash:false) { |v| v.to_s }
        # # returns { a:"1", b:"{ c=>1 }
        # ex: { a:1, b:{ c:1 } }.change_values(skip_hash:true) { |v| v.to_s }
        # # returns { a:"1", b:{ c=>"1" } }
        def change_values(options = {}, &block)
          deep_dup.change_values!(options, &block)
        end

        def change_values!(options = {}, &block)
          Hash::ValueChanger.new(options, &block).change(self)
        end

        # Changes the key of the hash without changing it
        #
        # @return [::Hash] new hash
        #
        # @example
        #   hash = { a: 1, b: 2 }
        #   hash.remap_keys(a: :b, b: :c) # returns { b: 1, c: 2 }
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

        # changes the text of the keys
        # options {
        #  recursive: true,
        #  type: :keep [keep, string, symbol] (key type to be returned)
        # }
        # ex: { :a => 1, "b"=> 2 }.change_key_text{ |key| key.upcase }
        # # returns { :A => 1, "B"=> 2 }
        def change_key_text(options = {}, &block)
          Hash::KeyChanger.new(self).change_text(options, &block)
        end
      end
    end
  end
end
