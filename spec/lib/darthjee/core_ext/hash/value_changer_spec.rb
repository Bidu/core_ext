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

      context 'when passing skip inner option' do
        let(:options) { { skip_inner: true } }

        it 'does not iterate over array' do
          expect(changer.change(object)).to eq({ a: { b: 3 } })
        end
      end

      context 'when passing skip inner and skiping recursion option' do
        let(:options) { { skip_inner: true, recursive: false } }

        it 'does not iterate over array' do
          expect(changer.change(object)).to eq({ a: { b: 333 } })
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

      context 'when passing skip inner option' do
        let(:options) { { skip_inner: true } }

        it 'does not iterate over array' do
          expect(changer.change(object)).to eq({ a: [{ b: 3 }] })
        end
      end

      context 'when passing skip inner and skiping recursion option' do
        let(:options) { { skip_inner: true, recursive: false } }

        it 'does not iterate over array' do
          expect(changer.change(object)).to eq({ a: [{ b: 333 }] })
        end
      end
    end
  end
end
