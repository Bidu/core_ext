require 'darthjee/core_ext/array/hash_builder'

class Array
  def procedural_join(extractor, &block)
    list = dup
    prev = init = list.shift

    list = list.map do |val|
      [
        yield(prev, val),
        extractor.call(val)
      ].tap {
        prev = val
      }
    end

    list.unshift(extractor.call(init))
    list.join
  end

  def chain_map(*methods)
    result = self
    result = result.map(&(methods.shift)) until methods.empty?

    return result unless block_given?
    result.map { |*args| yield(*args) }
  end

  def as_hash(keys)
    Array::HashBuilder.new(self, keys).build
  end

  def random
    self[rand(size)]
  end

  def random!
    self.slice!(rand(size))
  end
end
