# frozen_string_literal: true

class DefaultReaderModel
  attr_writer :name, :cars

  default_reader :name, 'John'
  default_readers :cars, :houses, 2
end
