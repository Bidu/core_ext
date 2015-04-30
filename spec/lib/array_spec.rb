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

  describe '#map_and_find' do
    let(:array) { [1, 2, 3, 4] }
    let(:value) { array.map_and_find(&block) }

    context 'when block returns nil' do
      let(:block) { proc {} }
      it { expect(value).to be_nil }
    end

    context 'when block returns false' do
      let(:block) { proc { false } }
      it { expect(value).to be_nil }
    end

    context 'when block returns a true evaluated value' do
      let(:block) { proc(&:to_s) }

      it { expect(value).to eq('1') }

      context 'but not for the first value' do
        let(:transformer) { double(:transformer) }
        let(:block) { proc { |v| transformer.transform(v) } }

        before do
          allow(transformer).to receive(:transform) do |v|
            v.to_s if v > 1
          end
          value
        end

        it { expect(value).to eq('2') }
        it 'calls the mapping only until it returns a valid value' do
          expect(transformer).to have_received(:transform).exactly(2)
        end
      end
    end
  end
end
