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
  end
end
