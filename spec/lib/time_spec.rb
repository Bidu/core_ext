# frozen_string_literal: true

require 'spec_helper'

describe Time do
  let(:year) { 2018 }
  let(:month) { 10 }
  let(:day) { 4 }
  let(:subject) { Time.new(year, month, day, 10, 0, 0) }

  describe '#days_between' do
    it_behaves_like 'an object that knows how to calculate days between'
  end
end
