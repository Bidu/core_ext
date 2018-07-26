# frozen_string_literal: true

require 'spec_helper'

describe Date do
  let(:year) { 2018 }
  let(:month) { 10 }
  let(:day) { 4 }
  let(:subject) { Date.new(year, month, day) }

  describe '#days_between' do
    it_behaves_like 'an object that knows how to calculate days between'
  end
end
