require 'spec_helper'

describe Array do
  describe '#as_hash' do
    let(:array) { [1, 2, 3] }
    let(:keys) { %w(a b c) }
    let(:expected) { { 'a' => 1, 'b' => 2, 'c' => 3 } }

    it 'creates a hash using the array as value and the argument as keys' do
      expect(array.as_hash(keys)).to eq(expected)
    end

    context 'when there are more keys than values' do
      let(:keys) { %w(a b c d e f) }
      let(:expected) { { 'a' => 1, 'b' => 2, 'c' => 3, 'd' => nil, 'e' => nil, 'f' => nil } }

      it 'creates a hash with nil values for the extra keys' do
        expect(array.as_hash(keys)).to eq(expected)
      end

      it { expect { array.as_hash(keys) }.not_to change { keys } }
      it { expect { array.as_hash(keys) }.not_to change { array } }
    end

    context 'when there are more values than keys' do
      let(:array) { [1, 2, 3, 4, 5, 6, 7] }

      it { expect { array.as_hash(keys) }.to raise_error(IndexError) }

      it { expect { array.as_hash(keys) rescue nil }.not_to change { keys } }
      it { expect { array.as_hash(keys) rescue nil }.not_to change { array } }
    end
  end
end
