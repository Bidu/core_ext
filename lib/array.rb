require 'array/hash_builder'

class Array
  def chain_map(*methods)
    result = self
    result = result.map(&(methods.shift)) until methods.empty?
    result
  end

  def as_hash(keys)
    Array::HashBuilder.new(self, keys).build
  end
end
