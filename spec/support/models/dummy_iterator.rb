# frozen_string_literal: true

class DummyIterator
  def initialize(array)
    @array = array
  end

  def map(*args, &block)
    @array.map(*args, &block)
  end

  def each(*args, &block)
    @array.each(*args, &block)
  end
end
