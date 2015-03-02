require 'array/hash_builder'

class Array
  def as_hash(keys)
    Array::HashBuilder.new(self, keys).build
  end
end
