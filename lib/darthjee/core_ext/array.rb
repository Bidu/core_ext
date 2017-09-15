require 'darthjee/core_ext/array/hash_builder'

class Array
  def procedural_join(mapper = proc(&:to_s), &block)
    return '' if empty?
    list = dup
    prev = first
    list[0] = mapper.call(prev).to_s

    list.inject do |string, val|
      "#{string}#{yield(prev,val)}#{mapper.call(val)}".tap do
        prev = val
      end
    end
  end

  def chain_map(*methods, &block)
    result = methods.inject(self) do |array, method|
      array.map(&method)
    end

    return result unless block_given?
    result.map(&block)
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
