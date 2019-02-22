# frozen_string_literal: true

require 'spec_helper'

describe Math do
  describe '.average' do
    context 'when passing an array of values' do
      let(:values) { [0, 1, 2, 3, 4] }

      it 'returns the average' do
        expect(described_class.average(values)).to eq(2)
      end

      context 'when average is not a round number' do
        let(:values) { [0, 1, 2, 3] }

        it 'returns the average' do
          expect(described_class.average(values)).to eq(1.5)
        end
      end
    end

    context 'when passing a hash' do
      let(:values) do
        {
          0 => 1,
          1 => 2,
          2 => 3,
          3 => 4,
          4 => 5
        }
      end

      it 'uses the keys as values and the values as weights (frequency)' do
        expect(described_class.average(values)).to eq(8 / 3.0)
      end
    end
  end
end
