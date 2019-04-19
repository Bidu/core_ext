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
        expect(changer.change(object)).to eq(a: 2, b: 3)
      end
    end

    context 'when object is an array' do
      let(:object) { [{ a: 22 }, { b: 333 }] }

      it 'iterates over array' do
        expect(changer.change(object)).to eq([{ a: 2 }, { b: 3 }])
      end

      it 'changes original array' do
        expect { changer.change(object) }.to(change { object })
      end

      context 'when skiping recursion option' do
        let(:options) { { recursive: false } }

        it 'iterates over main array' do
          expect(changer.change(object)).to eq([{ a: 2 }, { b: 3 }])
        end
      end

      context 'when passing skip inner option as false' do
        let(:options) { { skip_inner: false } }

        it 'does not consider values as inner hashes' do
          expect(changer.change(object)).to eq([{ a: 2 }, { b: 3 }])
        end
      end

      context 'when passing skip inner false and skiping recursion option' do
        let(:options) { { skip_inner: false, recursive: false } }

        it 'does not consider values as inner hashes' do
          expect(changer.change(object)).to eq([{ a: 2 }, { b: 3 }])
        end
      end
    end

    context 'when there is an inner hash' do
      let(:object) { { a: { b: 333 } } }

      it 'iterates over inner hash' do
        expect(changer.change(object)).to eq(a: { b: 3 })
      end

      context 'when skiping recursion option' do
        let(:options) { { recursive: false } }

        it 'does not iterate over array' do
          expect(changer.change(object)).to eq(a: { b: 333 })
        end
      end

      context 'when passing skip inner option as false' do
        let(:options) { { skip_inner: false } }

        it 'apply change on inner hash' do
          expect(changer.change(object)).to eq(a: 9)
        end
      end

      context 'when passing skip inner false and skiping recursion option' do
        let(:options) { { skip_inner: false, recursive: false } }

        it 'applies the transformation before attempting recusrsive' do
          expect(changer.change(object)).to eq(a: 9)
        end
      end
    end

    context 'when values are arrays' do
      let(:object) { { a: [{ b: 333 }] } }

      it 'iterates over array and inner hash' do
        expect(changer.change(object)).to eq(a: [{ b: 3 }])
      end

      context 'when skiping recursion option' do
        let(:options) { { recursive: false } }

        it 'does not iterate over array' do
          expect(changer.change(object)).to eq(a: [{ b: 333 }])
        end
      end

      context 'when passing skip inner option as false' do
        let(:options) { { skip_inner: false } }

        it 'applies transformation over inner hash' do
          expect(changer.change(object)).to eq(a: 11)
        end
      end

      context 'when passing skip inner false and skiping recursion option' do
        let(:options) { { skip_inner: false, recursive: false } }

        it 'applies transformation before going recursive' do
          expect(changer.change(object)).to eq(a: 11)
        end
      end
    end

    context 'when values are arrays within arrays' do
      let(:object) { { a: [[100], [1000]] } }

      it 'iterates over the inner arrays' do
        expect(changer.change(object)).to eq(a: [[3], [4]])
      end

      context 'when skiping recursion option' do
        let(:options) { { recursive: false } }

        it 'does not iterate over array' do
          expect(changer.change(object)).to eq(a: [[100], [1000]])
        end
      end

      context 'when passing skip inner option as false' do
        let(:options) { { skip_inner: false } }

        it 'applies transformation over the whole array' do
          expect(changer.change(object)).to eq(a: 15)
        end
      end

      context 'when passing skip inner false and skiping recursion option' do
        let(:options) { { skip_inner: false, recursive: false } }

        it 'applies transformation before going recursive' do
          expect(changer.change(object)).to eq(a: 15)
        end
      end
    end

    context 'when object is an array of arrays' do
      let(:object) { [[{ a: 100 }], [{ b: { c: 1000 } }]] }

      it 'iterates over the inner arrays' do
        expect(changer.change(object)).to eq([[{ a: 3 }], [{ b: { c: 4 } }]])
      end

      context 'when skiping recursion option' do
        let(:options) { { recursive: false } }

        it 'stops recursive after the first hash' do
          expected = [[{ a: 3 }], [{ b: { c: 1000 } }]]
          expect(changer.change(object)).to eq(expected)
        end
      end

      context 'when passing skip inner option as false' do
        let(:options) { { skip_inner: false } }

        it 'applies transformation on the first value of a hash' do
          expect(changer.change(object)).to eq([[{ a: 3 }], [{ b: 10 }]])
        end
      end

      context 'when passing skip inner false and skiping recursion option' do
        let(:options) { { skip_inner: false, recursive: false } }

        it 'applies transformation before going recursive' do
          expect(changer.change(object)).to eq([[{ a: 3 }], [{ b: 10 }]])
        end
      end
    end

    context 'when transformation returns a hash and skip_inner is false' do
      let(:object) { { a: [{ b: 333 }], c: { d: 10 }, e: [] } }
      let(:options) { { skip_inner: false } }
      let(:block) do
        proc do |value|
          value.is_a?(Array) ? { size: value.size } : value.to_s.size
        end
      end

      it 'treat result of transformation as new hashes to be transformed' do
        expected = { a: { size: 1 }, c: 8, e: { size: 1 } }
        expect(changer.change(object)).to eq(expected)
      end

      context 'when skipping recursion' do
        let(:options) { { skip_inner: false, recursive: false } }

        it 'does not iterate over returned hash' do
          expected = { a: { size: 1 }, c: 8, e: { size: 0 } }
          expect(changer.change(object)).to eq(expected)
        end
      end
    end

    context 'when value is not an array but responds to #map' do
      let(:array)  { [{ b: 22 }, { c: 333 }] }
      let(:object) { { a: DummyIterator.new(array) } }

      it 'iterates over array' do
        expected = { a: [{ b: 2 }, { c: 3 }] }
        expect(changer.change(object)).to eq(expected)
      end

      it 'change original array' do
        expect { changer.change(object) }.to(change { array })
      end
    end

    context 'when object is not an array but responds to #map' do
      let(:array) { [{ b: 22 }, { c: 333 }] }
      let(:object) { DummyIterator.new(array) }

      it 'iterates over array' do
        expected = [{ b: 2 }, { c: 3 }]
        expect(changer.change(object)).to eq(expected)
      end

      it 'changes original array' do
        expect { changer.change(object) }.to(change { array })
      end
    end
  end
end
