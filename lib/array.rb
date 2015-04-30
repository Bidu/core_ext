require 'array/hash_builder'

class Array
  def chain_map(*methods)
    result = self
    result = result.map(&(methods.shift)) until methods.empty?
    
    return result unless block_given?
    result.map { |*args| yield(*args) }
  end

  def as_hash(keys)
    Array::HashBuilder.new(self, keys).build
  end
end
