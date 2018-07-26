# frozen_string_literal: true

require 'spec_helper'

describe Numeric do
  describe '#percent_of' do
    context 'when number is float' do
      let(:number) { 120.0 }

      it 'converts to percentage of number' do
        expect(number.percent_of(240)).to eq(50)
      end

      it 'converts to percentage of number' do
        expect(number.percent_of(60)).to eq(200)
      end

      it 'do not raise an error when divisor is 0' do
        expect(100.0.percent_of(0)).to eq(Float::INFINITY)
      end

      it 'do not raise an error when divisor is 0.0' do
        expect(100.0.percent_of(0.0)).to eq(Float::INFINITY)
      end
    end

    context 'when number is integer' do
      it 'converts to percentage of number' do
        expect(500.percent_of(50)).to eq(1000)
      end

      it 'converts to percentage of number' do
        expect(0.percent_of(50)).to eq(0)
      end

      it 'converts to percentage of number' do
        expect(10.percent_of(100)).to eq(10)
      end

      it 'do not raise an error when divisor is 0' do
        expect(100.percent_of(0)).to eq(Float::INFINITY)
      end
    end

    context 'when a number is 0' do
      context 'when divident is 0' do
        it { expect(0.percent_of(100)).to eq(0) }
      end

      context 'when divisor is 0' do
        it { expect(100.percent_of(0)).to eq(Float::INFINITY) }
      end

      context 'both are 0' do
        it { expect(0.percent_of(0)).to eq(Float::INFINITY) }
      end
    end

    context 'when divisor is nil' do
      it { expect(100.percent_of(nil)).to eq(Float::INFINITY) }
    end
  end
end
