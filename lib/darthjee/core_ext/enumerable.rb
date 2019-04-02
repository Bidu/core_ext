# frozen_string_literal: true

# @api public
module Enumerable
  # Removes any element that is nil or empty
  #
  # @see #clean!
  #
  # This method does not change the original
  # enumerable
  #
  # @example cleaning a Hash
  #   hash = {
  #     keep: 'value',
  #     nil_value: nil,
  #     empty_array: [],
  #     empty_string: '',
  #     empty_hash: {}
  #   }
  #
  #   hash.clean  # returns { keep: 'value' } without changing the hash
  #
  # @example cleaning an Array
  #   array = ['value', nil, [], '', {}]
  #
  #   array.clean  # returns ['value'] without changing the array
  # @return [::Enumerable] same class of +self+
  def clean
    deep_dup.clean!
  end

  # Removes any element that is nil or empty
  #
  # @return [::Enumerable] the enumerable itself
  #
  # @example cleaning a Hash
  #   hash = {
  #     keep: 'value',
  #     nil_value: nil,
  #     empty_array: [],
  #     empty_string: '',
  #     empty_hash: {}
  #   }
  #
  #   hash.clean! # changes the hash to { keep: 'value' }
  #
  # @example cleaning an Array
  #   array = ['value', nil, [], '', {}]
  #
  #   array.clean! # changes the array to be  ['value']
  #
  # @return [::Enumerable] same class of +self+
  def clean!
    if is_a?(Hash)
      delete_if { |_k, v| empty_value?(v) }
    else
      delete_if { |v| empty_value?(v) }
    end
  end

  # Maps the elements into a new value, returning only one
  #
  # The result to be returned is
  # the first mapping that is evaluated to true
  #
  # This method is equivalent to #map#find but
  # only calling the map block up to when a value
  # is found
  #
  # @yield (*args) mappig block
  #
  # @example Using an array of keys to remove remove elements of a hash
  #
  #   service_map = {
  #     a: nil,
  #     b: false,
  #     c: 'found me',
  #     d: nil,
  #     e: 'didnt find me'
  #   }
  #
  #   keys = %i[a b c d e]
  #
  #   keys.map_and_find do |key|   #
  #     service_values.delete(key) #
  #   end                          # returns 'found me'
  #
  #   service_map # has lost only 3 keys returning
  #               # { d: nil, e: 'didnt find me' }
  #
  # @return [::Object]
  def map_and_find
    mapped = nil
    find do |*args|
      mapped = yield(*args)
    end
    mapped || nil
  end

  # Maps the elements into a new value returning a subset
  #
  # The subset returned has the values mapped to non
  # false values
  #
  # This method is equivalent to call #map#select
  #
  # @yield (*args) mapping block
  #
  # @example Mapping the values of hash to their size
  #   hash = {
  #     a: nil,
  #     b: 'aka',
  #     c: 'a'
  #   }
  #
  #   values = hash.map_and_select do |key, value|
  #     value && value.to_s
  #   end
  #
  #   values # returns [3, 1]
  #
  # @return [::Array<::Object>]
  def map_and_select
    mapped = map do |*args|
      yield(*args)
    end
    mapped.select { |e| e }
  end

  # Maps values and creates a hash
  #
  # The keys will be the original values used in the
  # mapping and the values the result of the #map
  #
  # @yield (*args) the mapping block
  #
  # @example Mapping strings to their sizes
  #   strings =  %w[word big_word]
  #
  #   strings.map_to_hash(&:size) # returns { 'word' => 4, 'big_word' => 8 }
  # @return [::Hash]
  def map_to_hash
    {}.tap do |hash|
      each do |element|
        hash[element] = yield(element)
      end
    end
  end

  private

  # @api private
  #
  # @private
  #
  # Checks if a value is considered empty
  #
  # This also clean empty values
  #
  # @return [::TrueClass,::FalseClass]
  def empty_value?(value)
    return true if value.nil? || value.try(:empty?)
    return unless value.is_a?(Hash) || value.is_a?(Array)
    value.clean!.empty?
  end
end
