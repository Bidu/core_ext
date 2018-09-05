# frozen_string_literal: true

module Darthjee
  module CoreExt
    module Numeric
      def percent_of(total)
        return Float::INFINITY if total&.zero?
        (to_f / total.to_f) * 100.0
      end
    end
  end
end

class Numeric
  include Darthjee::CoreExt::Numeric
end
