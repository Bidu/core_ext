# frozen_string_literal: true

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
end
