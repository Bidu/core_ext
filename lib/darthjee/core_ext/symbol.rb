# frozen_string_literal: true

module Darthjee
  module CoreExt
    module Symbol
      def camelize(type = :upper)
        to_s.camelize(type).to_sym
      end

      def underscore
        to_s.underscore.to_sym
      end
    end
  end
end

class Symbol
  include Darthjee::CoreExt::Symbol
end
