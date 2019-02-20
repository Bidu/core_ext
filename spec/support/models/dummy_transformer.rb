# frozen_string_literal: true

class DummyTransformer
  def initialize(&block)
    @block = block
  end

  def transform(value)
    block.call(value)
  end

  private

  attr_reader :block
end
