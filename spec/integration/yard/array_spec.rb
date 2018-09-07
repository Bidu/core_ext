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
end
