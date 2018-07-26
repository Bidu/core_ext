module Enumerable
  def clean
    deep_dup.clean!
  end

  # delete hash or array values if value is nil
  # ex: { a: nil, b: 2 }.clean! => { b: 2 }
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
