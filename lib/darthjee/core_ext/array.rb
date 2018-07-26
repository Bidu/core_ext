# frozen_string_literal: true

class Array
  autoload :HashBuilder, 'darthjee/core_ext/array/hash_builder'

  def mapk(*keys)
    keys.inject(self) do |enum, key|
      enum.map { |hash| hash[key] }
    end
  end

  def procedural_join(mapper = proc(&:to_s))
    return '' if empty?
    list = dup
    prev = first
    list[0] = mapper.call(prev).to_s

    list.inject do |string, val|
      j = yield(prev, val) if block_given?
      "#{string}#{j}#{mapper.call(val)}".tap do
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
