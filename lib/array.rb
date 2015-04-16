require 'array/hash_builder'

class Array
  def as_hash(keys)
    Array::HashBuilder.new(self, keys).build
  end

  def find_map
    mapped = nil
    find do |value|
      mapped = yield(value)
    end
    mapped || nil
  end
end
