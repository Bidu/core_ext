# frozen_string_literal: true

require 'active_support/all'
require 'darthjee/core_ext/array'
require 'darthjee/core_ext/class'
require 'darthjee/core_ext/date'
require 'darthjee/core_ext/enumerable'
require 'darthjee/core_ext/math'
require 'darthjee/core_ext/numeric'
require 'darthjee/core_ext/object'
require 'darthjee/core_ext/symbol'
require 'darthjee/core_ext/time'

module Darthjee
  module CoreExt
    PATH = 'darthjee/core_ext'

    require 'darthjee/core_ext/version'

    require 'darthjee/core_ext/hash'
  end
end
