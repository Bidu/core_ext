require 'spec_helper'

describe Array do
  describe '#chain_map' do
    let(:array) { [ :a, :long_name, :sym ] }
    let(:mapped) { array.chain_map(:to_s, :size, :to_s) }

    it 'calls each argument as method of the mapped result' do
      expect(mapped).to eq([ '1', '9', '3' ])
    end

    context 'when an extra block is given' do
      let(:mapped) do
        array.chain_map(:to_s, :size) do |v|
          "final: #{v}"
        end
      end

      it 'calls each argument as method of the mapped result' do
        expect(mapped).to eq([ 'final: 1', 'final: 9', 'final: 3' ])
      end
    end
  end

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

  describe '#random' do
    let(:array) { [ 7, 5, 3 ] }

    (0..2).each do |index|
      context "when random returns #{index}" do
        before do
          allow_any_instance_of(Array).to receive(:rand).with(array.size) { index }
        end

        it 'returns the randomized index of the array' do
          expect(array.random).to eq(array[index])
        end
      end
    end
  end
end
