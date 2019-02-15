# frozen_string_literal: true

require 'spec_helper'

describe Darthjee::CoreExt::Hash::ValueChanger do
  subject(:changer) { described_class.new(options, &block) }

  let(:block) { proc { |value| value.to_s.size } }

  describe '#change' do
    let(:options) { {} }

    context 'when object is a Hash' do
      let(:object) { { a: 22, b: 333 } }

      it 'returns the hash with changed values' do
        expect(changer.change(object)).to eq({ a: 2, b: 3 })
      end
    end

    context 'when object is an array' do
      let(:object) { [{ a: 22 }, { b: 333 }] }

      it 'iterates over array' do
        expect(changer.change(object)).to eq([{ a: 2 }, { b: 3 }])
      end
    end

    context 'when there is an inner hash' do
      let(:object) { { a: { b: 333 } } }

      it 'iterates over inner hash' do
        expect(changer.change(object)).to eq({ a: { b: 3 } })
      end

      context 'when skiping recursion option' do
        let(:options) { { recursive: false } }

        it 'does not iterate over array' do
          expect(changer.change(object)).to eq({ a: { b: 333 } })
        end
      end

      context 'when passing skip inner option as false' do
        let(:options) { { skip_inner: false } }

        it 'apply change on inner hash' do
          expect(changer.change(object)).to eq({ a: 9 })
        end
      end

      context 'when passing skip inner false and skiping recursion option' do
        let(:options) { { skip_inner: false, recursive: false } }

        it 'applies the transformation before attempting recusrsive' do
          expect(changer.change(object)).to eq({ a: 9 })
        end
      end
    end

    context 'when values are arrays' do
      let(:object) { { a: [{ b: 333 }] } }

      it 'iterates over array and inner hash' do
        expect(changer.change(object)).to eq({ a: [{ b: 3 }] })
      end

      context 'when skiping recursion option' do
        let(:options) { { recursive: false } }

        it 'does not iterate over array' do
          expect(changer.change(object)).to eq({ a: [{ b: 333 }] })
        end
      end

      context 'when passing skip inner option as false' do
        let(:options) { { skip_inner: false } }

        it 'applies transformation over inner hash' do
          expect(changer.change(object)).to eq({ a: 11 })
        end
      end

      context 'when passing skip inner false and skiping recursion option' do
        let(:options) { { skip_inner: false, recursive: false } }

        it 'applies transformation before going recursive' do
          expect(changer.change(object)).to eq({ a: 11 })
        end
      end
    end
  end
end
