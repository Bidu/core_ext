# frozen_string_literal: true

module Darthjee
  module CoreExt
    module Date
      def days_between(other_date)
        (self - other_date.to_date).abs
      end
    end
  end
end

class Date
  include Darthjee::CoreExt::Date
end
