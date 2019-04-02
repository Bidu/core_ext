# frozen_string_literal: true

module Darthjee
  module CoreExt
    # @api public
    module Date
      # Calculates the number of days between 2 dates
      #
      # @param [::Date,::Time] other_date future/past date for comparisom
      # @return [::Integer] days between two dates
      #
      # @example One year apart date
      #   date = Date.new(2018, 11, 21)
      #   other_date = Date.new(2019, 11, 21)
      #
      #   date.days_between(other_date)) # returns 365
      #
      # @example Four year apart date (having a leap year)
      #   date = Date.new(2018, 11, 21)
      #   other_date = Date.new(2014, 11, 21)
      #
      #   date.days_between(other_date)) # returns 365 * 4 + 1 = 1461
      #
      # @example Checking against time
      #   date = Date.new(2018, 11, 21)
      #   time = Time.new(2017, 11, 21, 12, 0, 0)
      #
      #   date.days_between(time)) # returns 365
      def days_between(other_date)
        (self - other_date.to_date).abs
      end
    end
  end
end

class Date
  include Darthjee::CoreExt::Date
end
