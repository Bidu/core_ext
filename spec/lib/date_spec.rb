# frozen_string_literal: true

require 'spec_helper'

describe Date do
  subject(:date) { described_class.new(year, month, day) }

  let(:year)    { 2018 }
  let(:month)   { 10 }
  let(:day)     { 4 }

  describe '#days_between' do
    it_behaves_like 'an object that knows how to calculate days between'
  end
end
