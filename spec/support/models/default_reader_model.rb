# frozen_string_literal: true

class DefaultReaderModel
  attr_writer :name

  default_reader :name, 'John'
end
