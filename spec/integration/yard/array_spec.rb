# frozen_string_literal: true

require 'spec_helper'

describe Array do
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
end
