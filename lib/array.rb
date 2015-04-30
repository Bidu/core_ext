require 'array/hash_builder'

class Array
  def chain_map(*methods)
  end

  def as_hash(keys)
    Array::HashBuilder.new(self, keys).build
  end
end
