require 'spec_helper'

describe Object do
  describe '#is_any?' do
    subject { 1 }

    it do
      expect(subject).to respond_to(:is_any?)
    end

    context 'when no argument is passed' do
      it do
        expect(subject.is_any?).to be_falsey
      end
    end

    context 'when passing the correct class as argument' do
      it do
        expect(subject.is_any?(subject.class)).to be_truthy
      end

      context 'along any other class' do
        it do
          expect(subject.is_any?(Symbol, subject.class)).to be_truthy
        end
      end
    end

    context 'when passing the wrong class' do
      it do
        expect(subject.is_any?(Symbol)).to be_falsey
      end
    end
  end

  describe '.default_value' do
    subject { DefaultValue.new }

    it 'accepts default value' do
      expect(subject.x).to eq(10)
    end

    it do
      expect(Object).not_to respond_to(:default_value)
    end
  end

  describe '.default_values' do
    subject { DefaultValue.new }

    it 'accepts default values' do
      expect(subject.y).to eq(20)
    end

    it 'accepts default values' do
      expect(subject.z).to eq(20)
    end

    it do
      expect(Object).not_to respond_to(:default_values)
    end
  end
end
