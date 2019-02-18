# frozen_string_literal: true

require 'spec_helper'

describe Darthjee::CoreExt::Array::HashBuilder do
  describe 'yard' do
    describe '#build' do
      subject { described_class.new(values, keys) }

      let(:values) { [10, 20, 30] }
      let(:keys)   { %i[a b c] }

      it 'builds a hash pairing the keys and values' do
        expect(subject.build).to eq(
          a: 10, b: 20, c: 30
        )
      end

      context 'when trying to rebuild a hash' do
        let(:hash)   { { a: 20, b: 200, c: 2000 } }
        let(:values) { hash.values }
        let(:keys)   { hash.keys }

        it 'rebuilds the original hash' do
          expect(subject.build).to eq(hash)
        end
      end
    end
  end
end
