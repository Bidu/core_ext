# frozen_string_literal: true

module Enumerable
  def clean
    deep_dup.clean!
  end

  # Removes any element that is nil or empty
  #
  # @returns [::Enumerable] the enumerable itself
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

  def map_and_find
    mapped = nil
    find do |*args|
      mapped = yield(*args)
    end
    mapped || nil
  end

  def map_and_select
    mapped = map do |*args|
      yield(*args)
    end
    mapped.select { |e| e }
  end

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
