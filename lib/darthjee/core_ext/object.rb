# frozen_string_literal: true

require 'darthjee/core_ext/object/default_value'

module Darthjee
  module CoreExt
    module Object
      def is_any?(*classes)
        classes.any? do |clazz|
          is_a?(clazz)
        end
      end
    end
  end
end

class Object
  include Darthjee::CoreExt::Object

  class << self
    include Darthjee::CoreExt::Object::DefaultValue
  end
end
