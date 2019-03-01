# frozen_string_literal: true

require 'spec_helper'

describe Class do
  describe '.default_value' do
    subject(:model) { DefaultValueModel.new }

    it 'accepts default value' do
      expect(model.x).to eq(10)
    end

    it do
      expect(Object).not_to respond_to(:default_value)
    end
  end

  describe '.default_values' do
    subject(:model) { DefaultValueModel.new }

    it 'accepts default values for first method' do
      expect(model.y).to eq(20)
    end

    it 'accepts default values for second method' do
      expect(model.z).to eq(20)
    end

    it do
      expect(Object).not_to respond_to(:default_values)
    end
  end

  describe '.default_reader' do
    subject(:model) { DefaultReaderModel.new }

    it 'returns the default value' do
      expect(model.x).to eq(10)
    end

    context 'when the value is set with a new value' do
      before { model.x = 20 }

      it 'returns the new value' do
        expect(model.x).to eq(20)
      end
    end

    context 'when the value is set to be false' do
      before { model.x = false }

      it do
        expect(model.x).to be_falsey
      end
    end

    context 'when the value is set to be nil' do
      before { model.x = nil }

      it do
        expect(model.x).to be_nil
      end
    end
  end
end
