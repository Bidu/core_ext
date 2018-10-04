# frozen_string_literal: true

require 'spec_helper'

describe Array do
  describe 'yard' do
    describe '#average' do
      subject(:array) { [1, 2, 3, 4] }

      it 'returns the average' do
        expect(array.average).to eq(2.5)
      end
    end

    describe '#mapk' do
      let(:array) { [{ a: { b: 1 }, b: 2 }, { a: { b: 3 }, b: 4 }] }

      describe 'when passing just the first key' do
        it 'returns the array mapped ' do
          expect(array.mapk(:a)).to eq([{ b: 1 }, { b: 3 }])
        end
      end

      describe 'when passing a second key' do
        it 'chain fetches the key' do
          expect(array.mapk(:a, :b)).to eq([1, 3])
        end
      end

      describe 'when fetching a non existing key' do
        it 'returns nil for value' do
          expect(array.mapk(:c)).to eq([nil, nil])
        end
      end

      describe 'when element is not a hash' do
        it 'returns nil for value' do
          expect(array.mapk(:c, :d)).to eq([nil, nil])
        end
      end
    end

    describe '#procedural_join' do
      let(:array) { [1, 2, -3, -4, 5] }

      context 'when not mapping the value' do
        context 'when creating a sum' do
          let(:result) do
            array.procedural_join do |_previous, nexte|
              nexte.positive? ? '+' : ''
            end
          end

          it 'creates a sum' do
            expect(result).to eq('1+2-3-4+5')
          end
        end
      end

      context 'when mapping the value' do
        let(:result) do
          mapper = proc { |value| value.to_f.to_s }
          array.procedural_join(mapper) do |_previous, nexte|
            nexte.positive? ? ' +' : ' '
          end
        end

        it 'maps the value on the output' do
          expect(result).to eq('1.0 +2.0 -3.0 -4.0 +5.0')
        end
      end
    end

    describe '#chain_main' do
      let(:words) { %w[big_word tiny oh_my_god_such_a_big_word] }

      context 'when not passing a block' do
        let(:words) { %w[big_word tiny oh_my_god_such_a_big_word] }

        it 'calls the methods in a succession to map' do
          output = words.chain_map(:size, :to_f, :to_s)
          expect(output).to eq(%w[8.0 4.0 25.0])
        end
      end

      context 'when passing a block' do
        it 'mapps with the block at the end' do
          output = words.chain_map(:size) do |size|
            (size % 2).zero? ? 'even size' : 'odd size'
          end
          expect(output).to eq(['even size', 'even size', 'odd size'])
        end
      end
    end

    describe '#as_hash' do
      let(:array) { %w[each word one key] }
      let(:keys)  { %i[a b c d] }

      it 'Uses the keys arra as keys of the hash' do
        expect(array.as_hash(keys)).to eq(
          a: 'each', b: 'word', c: 'one', d: 'key'
        )
      end
    end

    describe '#random' do
      let(:array) { [10, 20, 30] }

      it 'returns an element of the array' do
        expect(array).to include(array.random)
      end

      it do
        expect { array.random }.not_to(change { array })
      end
    end

    describe '#random!' do
      let(:array) { [10, 20, 30] }

      it 'returns an element of the array' do
        expect(array.dup).to include(array.random!)
      end

      it do
        expect { array.random! }.to(change { array })
      end
    end
  end
end
