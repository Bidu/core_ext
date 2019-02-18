# frozen_string_literal: true

module Enumerable
  # (see #clean!)
  #
  # This method does not change the original
  # enumerable
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
  #   hash.clean! # changes the hash to
  #               # { keep: 'value' }
  #
  # @example cleaning an Array
  #   array = ['value', nil, [], '', {}]
  #   array.clean! # changes the array to be
  #                # ['value']
  def clean!
    if is_a?(Hash)
      delete_if { |_k, v| empty_value?(v) }
    else
      delete_if { |v| empty_value?(v) }
    end
  end

  # Maps the elements into a new value, returning
  # the first element that is evaluated to true
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
  #   keys.map_and_find { |key| service_values.delete(key) }
  #               # returns 'found me'
  #   service_map # has lost only 3 keys returning
  #               # { d: nil, e: 'didnt find me' }
  def map_and_find
    mapped = nil
    find do |*args|
      mapped = yield(*args)
    end
    mapped || nil
  end

  # Maps the elements into a new value returning an
  # array of the values mapped to non false values
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
  def map_and_select
    mapped = map do |*args|
      yield(*args)
    end
    mapped.select { |e| e }
  end

  # Maps values and creates a hash whose values are
  # the result of the #map and the keys are the original values
  #
  # @yield (*args) the mapping block
  #
  # @example Mapping strings to their sizes
  #   strings =  %w[word big_word]
  #
  #   strings.map_to_hash(&:size) # returns { 'word' => 4, 'big_word' => 8 }
  def map_to_hash
    {}.tap do |hash|
      each do |element|
        hash[element] = yield(element)
      end
    end
  end

  private

  def empty_value?(value)
    value.nil? || value.try(:empty?) ||
      ((value.is_a?(Hash) || value.is_a?(Array)) && value.clean!.empty?)
  end
end
