# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'yardstick/rake/measurement'

RSpec::Core::RakeTask.new

Yardstick::Rake::Measurement.new(:yardstick_measure) do |measurement|
    measurement.output = 'measurement/report.txt'
end

# verify coverage
#
require 'yardstick/rake/verify'

Yardstick::Rake::Verify.new do |verify|
  verify.threshold = 54.7
end

task default: :spec
task test: :spec

