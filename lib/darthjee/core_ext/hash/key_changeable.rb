# frozen_string_literal: true

module Darthjee
  module CoreExt
    module Hash
      # Module holding methods responsible for changing / transforming keys of a Hash
      #
      # @api public
      module KeyChangeable
        # Changes the key of the hash without changing it
        #
        # @return [Hash] new hash
        #
        # @example
        #   hash = { a: 1, b: 2 }
        #   hash.remap_keys(a: :b, b: :c) # returns { b: 1, c: 2 }
        def remap_keys(remap)
          dup.remap_keys!(remap)
        end

        # Changes the key of the hash changing the original
        #
        # @return [Hash] self
        #
        # @example (see #remap_keys)
        def remap_keys!(keys_map)
          KeyChanger.new(self).remap(keys_map)
        end

        # Camelize all keys in the hash as `key.camelize(:lower)
        #
        # @return [Hash] the resulting hash
        #
        # @example
        #   hash = { first_key: 1, 'second_key' => 2 }
        #   hash.lower_camelize_keys # {
        #                            #   firstKey: 1,
        #                            #   'secondKey' => 2
        #                            # }
        #
        def lower_camelize_keys(options = {})
          dup.lower_camelize_keys!(options)
        end

        # Camelize all keys in the hash
        #
        # @return [Hash] self after changing the keys
        #
        # @example (see #lower_camelize_keys)
        def lower_camelize_keys!(options = {})
          options = options.merge(uppercase_first_letter: false)

          camelize_keys!(options)
        end

        def camelize_keys(options = {})
          dup.camelize_keys!(options)
        end

        def camelize_keys!(options = {})
          Hash::KeyChanger.new(self).camelize_keys(options)
        end

        def underscore_keys(options = {})
          dup.underscore_keys!(options)
        end

        def underscore_keys!(options = {})
          Hash::KeyChanger.new(self).underscore_keys(options)
        end

        # change all keys returning the new map
        # options: { recursive: true }
        # ex: { "a" =>1 }.change_keys{ |key| key.upcase } == { "A" => 1 }
        def change_keys(options = {}, &block)
          deep_dup.change_keys!(options, &block)
        end

        # change all keys returning the new map
        # options: { recursive: true }
        # ex: { "a":1 }.change_keys{ |key| key.upcase } == { "A":1 }
        def change_keys!(options = {}, &block)
          Hash::KeyChanger.new(self).change_keys(options, &block)
        end

        # change all publicaly sending method calls
        # options: { recursive: true }
        # ex: { a: 1 }.chain_change_keys(:to_s, :upcase) == { "A" =>1 }
        def chain_change_keys(*calls)
          deep_dup.chain_change_keys!(*calls)
        end

        # change all publicaly sending method calls
        # options: { recursive: true }
        # ex: { a: 1 }.chain_change_keys(:to_s, :upcase) == { "A" =>1 }
        def chain_change_keys!(*calls)
          options = calls.extract_options!

          calls.inject(self) do |h, m|
            h.change_keys!(options, &m)
          end
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
