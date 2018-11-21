# frozen_string_literal: true

module Darthjee
  module CoreExt
    module Hash
      # Module holding methods responsible for camelizing
      # keys of a hash
      #
      # @api public
      module Cameliazable
        # Change keys to CamelCase without changing the
        # original hash
        #
        # @return [::Hash] new hash with changed keys
        # @param [::Hash] options options of camelization
        # @option options [::Boolean] uppercase_first_letter: flag
        #   defining the type of CamelCase
        #
        # @see Hash::KeyChanger#camelize_keys
        #
        # @example
        #   hash = { first_key: 1, 'second_key' => 2 }
        #   hash.camelize_keys # returns {
        #                      #   FirstKey: 1,
        #                      #   'SecondKey' => 2
        #                      # }
        #
        # @example
        #   hash = { first_key: 1, 'second_key' => 2 }
        #   options = { uppercase_first_letter: false }
        #   hash.camelize_keys(options) # returns {
        #                               #   firstKey: 1,
        #                               #   'secondKey' => 2
        #                               # }
        #
        def camelize_keys(options = {})
          dup.camelize_keys!(options)
        end

        # Change keys to CamelCase changing the
        # original hash
        #
        # @return [::Hash] new hash with changed keys
        # @param [::Hash] options options of camelization
        # @option options [::Boolean] uppercase_first_letter: flag
        #   defining the type of CamelCase
        #
        # @example (#camelize_keys)
        #
        # @see #camelize_keys
        def camelize_keys!(options = {})
          Hash::KeyChanger.new(self).camelize_keys(options)
        end

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
