# frozen_string_literal: true

require 'spec_helper'

describe Darthjee::CoreExt::Hash::ValueChanger do
  describe 'yard' do
    subject(:changer) { described_class.new(options, &block) }

    describe '#initialize' do
      let(:options) { { recursive: false, skip_inner: false } }
      let(:block)   { proc(&:class) }
      let(:hash)    { { a: 1, b: { c: 2 }, d: [{ e: 1 }] } }

      it 'initialize options' do
        expect(changer.change(hash)).to eq(
          a: Integer, b: Hash, d: Array
        )
      end
    end

    describe '#change' do
      let(:options) { {} }
      let(:block) { proc { |value| value.to_s.size } }

      context 'when object is a Hash' do
        let(:hash) { { a: 15, b: { c: 2 }, d: [{ e: 100 }] } }

        it 'transforms values' do
          expect(changer.change(hash)).to eq(
            a: 2, b: { c: 1 }, d: [{ e: 3 }]
          )
        end

        context 'when not skipping inner' do
          let(:options) { { skip_inner: false } }

          it 'transforms values' do
            expect(changer.change(hash)).to eq(
              a: 2, b: 7, d: 11
            )
          end
        end

        context 'when skipping recursive' do
          let(:options) { { recursive: false } }

          it 'transforms values' do
            expect(changer.change(hash)).to eq(
              a: 2, b: { c: 2 }, d: [{ e: 100 }]
            )
          end
        end
      end

      context 'when object is an array' do
        let(:array) { [15, { c: 2 }, [{ e: 100 }]] }

        it 'transforms values' do
          expect(changer.change(array)).to eq(
            [2, { c: 1 }, [{ e: 3 }]]
          )
        end
      end
    end
  end
end
