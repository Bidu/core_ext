# frozen_string_literal: true

module Darthjee
  module CoreExt
    module Hash
      # Module holding methods responsible for camelizing
      # keys of a hash
      #
      # @api public
      module Cameliazable
        # Camelize all keys in the hash as `key.camelize(:lower)
        #
        # @return [::Hash] the resulting hash
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
        # @return [::Hash] self after changing the keys
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
      end
    end
  end
end
