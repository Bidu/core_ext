# frozen_string_literal: true

require 'spec_helper'

describe Array do
  it_behaves_like 'an array with map_to_hash method'

  describe '#mapk' do
    let(:array) { [{ a: { b: 1 }, b: 2 }, { a: { b: 3 }, b: 4 }] }

    it 'maps using the keys given as arguments' do
      expect(array.mapk(:a, :b)).to eq([1, 3])
    end

    describe 'when fetching a non existing key' do
      it 'returns nil for value' do
        expect(array.mapk(:c)).to eq([nil, nil])
      end
    end

    describe 'when element is not a hash' do
      it do
        expect(array.mapk(:c, :d)).to eq([nil, nil])
      end
    end
  end

  describe '#procedural_join' do
    let(:array) { [1, 2, -3, -4, 5] }
    let(:map_proc) { proc { |v| v > 0 ? v + 1 : v - 1 } }
    let(:result) do
      array.procedural_join(map_proc) do |previous, nexte|
        previous * nexte > 0 ? ',' : '|'
      end
    end

    it 'joins proceduraly' do
      expect(result).to eq('2,3|-4,-5|6')
    end

    it 'does not change the array' do
      expect do
        result
      end.not_to(change { array })
    end

    context 'when array is empty' do
      let(:array) { [] }

      it do
        expect do
          result
        end.not_to raise_error
      end

      it 'acts as join for an empty array' do
        expect(result).to eq(array.join)
      end
    end

    context 'when array has only one element' do
      let(:array) { [2] }

      it do
        expect do
          result
        end.not_to raise_error
      end

      it 'acts as map join for a single element array' do
        expect(result).to eq(array.map(&map_proc).join)
      end
    end

    context 'when no mapping proc is passed' do
      let(:result) do
        array.procedural_join do |previous, nexte|
          previous * nexte > 0 ? ',' : '|'
        end
      end

      it 'proceduraly joins without mapping' do
        expect(result).to eq('1,2|-3,-4|5')
      end
    end

    context 'when no block is given' do
      let(:result) do
        array.procedural_join(map_proc)
      end

      it 'acts as map join for a single element array' do
        expect(result).to eq(array.map(&map_proc).join)
      end
    end
  end

  describe '#chain_map' do
    let(:array) { %i[a long_name sym] }
    let(:mapped) { array.chain_map(:to_s, :size, :to_s) }

    it 'calls each argument as method of the mapped result' do
      expect(mapped).to eq(%w[1 9 3])
    end

    context 'when an extra block is given' do
      let(:mapped) do
        array.chain_map(:to_s, :size) do |v|
          "final: #{v}"
        end
      end

      it 'calls each argument as method of the mapped result' do
        expect(mapped).to eq(['final: 1', 'final: 9', 'final: 3'])
      end
    end
  end

  describe '#as_hash' do
    let(:array) { [1, 2, 3] }
    let(:keys) { %w[a b c] }
    let(:expected) { { 'a' => 1, 'b' => 2, 'c' => 3 } }

    it 'creates a hash using the array as value and the argument as keys' do
      expect(array.as_hash(keys)).to eq(expected)
    end

    context 'when there are more keys than values' do
      let(:keys) { %w[a b c d e f] }
      let(:expected) do
        {
          'a' => 1,
          'b' => 2,
          'c' => 3,
          'd' => nil,
          'e' => nil,
          'f' => nil
        }
      end

      it 'creates a hash with nil values for the extra keys' do
        expect(array.as_hash(keys)).to eq(expected)
      end

      it { expect { array.as_hash(keys) }.not_to(change { keys }) }
      it { expect { array.as_hash(keys) }.not_to(change { array }) }
    end

    context 'when there are more values than keys' do
      let(:array) { [1, 2, 3, 4, 5, 6, 7] }

      it { expect { array.as_hash(keys) }.to raise_error(IndexError) }
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
    it_behaves_like 'a method that returns a random element', :random

    let(:array) { [8, 4, 2] }

    it 'removes an the returned element' do
      expect do
        array.random
      end.not_to(change { array })
    end
  end

  describe '#random!' do
    it_behaves_like 'a method that returns a random element', :random!

    let(:array) { [8, 4, 2] }

    it 'removes an the returned element' do
      expect do
        array.random!
      end.to change { array.size }.by(-1)
    end
  end

  describe '#map_and_select' do
    let(:array) { [1, 2, 3, 4].map { |i| { value: i } } }
    let(:filtered) { array.map_and_select(&block) }

    context 'when block returns nil' do
      let(:block) { proc {} }
      it { expect(filtered).to be_empty }
    end

    context 'when block returns false' do
      let(:block) { proc { false } }
      it { expect(filtered).to be_empty }
    end

    context 'when block returns a true evaluated value' do
      let(:block) { proc(&:to_s) }

      it { expect(filtered).to eq(array.map(&:to_s)) }

      context 'but not for the first value' do
        let(:transformer) { double(:transformer) }
        let(:block) { proc { |v| transformer.transform(v) } }

        before do
          allow(transformer).to receive(:transform) do |v|
            v.to_s if v[:value] > 1
          end
          filtered
        end

        it { expect(filtered).to eq(array[1..-1].map(&:to_s)) }

        it 'calls the mapping only once per element' do
          expect(transformer).to have_received(:transform).exactly(4)
        end
      end
    end
  end
end
