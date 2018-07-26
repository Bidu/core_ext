# frozen_string_literal: true

require 'darthjee/core_ext/object/default_value'

class Object
  def is_any?(*classes)
    classes.any? do |clazz|
      is_a?(clazz)
    end
  end
end
