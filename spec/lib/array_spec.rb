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

  describe '#find_map' do
    let(:array) { [1, 2, 3] }
    let(:value) { array.find_map(&block) }

    context 'when block returns nil' do
      let(:block) { Proc.new {} }
      it { expect(value).to be_nil }
    end

    context 'when block returns false' do
      let(:block) { Proc.new { false } }
      it { expect(value).to be_nil }
    end

    context 'when block returns a true evaluated value' do
      let(:block) { Proc.new { |v| v.to_s } }

      it { expect(value).to eq('1') }

      context 'but not for the first value' do
        let(:block) { Proc.new { |v| v.to_s if v > 1 } }

        it { expect(value).to eq('2') }
      end
    end
  end
end
