# frozen_string_literal: true

require 'yardstick/rake/measurement'
require 'yardstick/rake/verify'

Yardstick::Rake::Verify.new do |verify|
  verify.threshold = 54.7
end

Yardstick::Rake::Measurement.new(:yardstick_measure) do |measurement|
    measurement.output = 'measurement/report.txt'
end

