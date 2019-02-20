# frozen_string_literal: true

require 'spec_helper'

describe Class do
  describe '.default_value' do
    subject { DefaultValueModel.new }

    it 'accepts default value' do
      expect(subject.x).to eq(10)
    end

    it do
      expect(Object).not_to respond_to(:default_value)
    end
  end

  describe '.default_values' do
    subject { DefaultValueModel.new }

    it 'accepts default values for first method' do
      expect(subject.y).to eq(20)
    end

    it 'accepts default values for second method' do
      expect(subject.z).to eq(20)
    end

    it do
      expect(Object).not_to respond_to(:default_values)
    end
  end
end
