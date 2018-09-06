# frozen_string_literal: true

module Darthjee
  module CoreExt
    module Class
      private

      def default_value(name, value)
        define_method(name) { |*_| value }
      end

      def default_values(*names, value)
        names.each do |name|
          default_value(name, value)
        end
      end
    end
  end
end

class Class
  include Darthjee::CoreExt::Class
end
