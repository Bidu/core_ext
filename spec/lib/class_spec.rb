# frozen_string_literal: true

require 'spec_helper'

describe Class do
  describe '.default_value' do
    subject(:model) { DefaultValueModel.new }

    it 'accepts default value' do
      expect(model.x).to eq(10)
    end

    context 'when changing the instance of default value' do
      before do
        model.array[1] = 30
      end

      it 'changes the value for the instance' do
        expect(model.array).to eq([10, 30])
      end

      it 'changes the value for new instances' do
        expect(model.class.new.array).to eq([10, 30])
      end
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

    context 'when changing the instance of default value' do
      before do
        model.hash[:a] = 2
      end

      it 'changes the value for the instance' do
        expect(model.hash).to eq(a: 2)
      end

      it 'changes the value for new instances' do
        expect(model.class.new.hash).to eq(a: 2)
      end

      it 'changes the value for all methods' do
        expect(model.json).to eq(a: 2)
      end
    end
  end

  describe '.default_reader' do
    subject(:model) { DefaultReaderModel.new }

    it 'returns the default value' do
      expect(model.name).to eq('John')
    end

    context 'when the variable is set with a new value' do
      before { model.name = 'Bob' }

      it 'returns the new value' do
        expect(model.name).to eq('Bob')
      end
    end

    context 'when the variable is set to be false' do
      before { model.name = false }

      it do
        expect(model.name).to be_falsey
      end
    end

    context 'when the variable is set to be nil' do
      before { model.name = nil }

      it do
        expect(model.name).to be_nil
      end
    end

    context 'when changing the value of one instance' do
      it 'does not change the value of other instances' do
        expect { model.name = 'Bob' }
          .not_to(change { model.class.new.name })
      end
    end

    it do
      expect(Object).not_to respond_to(:default_value)
    end
  end

  describe '.default_readers' do
    subject(:model) { DefaultReaderModel.new }

    context 'when calling first method' do
      it 'returns the default value' do
        expect(model.cars).to eq(2)
      end

      context 'when the value is set with a new value' do
        before { model.cars = 10 }

        it 'returns the new value' do
          expect(model.cars).to eq(10)
        end

        it 'does not affect second method' do
          expect(model.houses).to eq(2)
        end
      end
    end

    it do
      expect(Object).not_to respond_to(:default_readers)
    end
  end
end
