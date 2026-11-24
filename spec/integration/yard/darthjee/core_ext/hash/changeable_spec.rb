# frozen_string_literal: true

describe Darthjee::CoreExt::Hash::Changeable do
  describe '#change_values' do
    describe 'Simple usage' do
      subject(:hash) { { a: 1, b: 2 } }

      it 'changes the values' do
        expect(hash.change_values { |value| value + 1 })
          .to eq(a: 2, b: 3)
      end
    end

    describe 'Skipping inner hash transformation' do
      subject(:hash) { { a: 1, b: { c: 1 } } }

      it 'changes the values' do
        expect(hash.change_values(&:to_s))
          .to eq(a: '1', b: { c: '1' })
      end
    end

    describe 'Not skipping inner hash transformation' do
      subject(:hash) { { a: 1, b: { c: 1 } } }

      it 'changes the values' do
        expect(hash.change_values(skip_inner: false, &:to_s))
          .to eq(a: '1', b: '{c: 1}')
      end
    end
  end

  describe '#change_values!' do
    subject(:hash) { { a: 1, b: inner_hash } }

    let(:inner_hash) { { c: 2 } }

    describe 'Changing inner hash' do
      it 'changes the original hash' do
        expect { hash.change_values!(&:to_s) }
          .to change { hash }
          .from(a: 1, b: { c: 2 })
          .to(a: '1', b: { c: '2' })
      end

      it 'changes the inner hash' do
        expect { hash.change_values!(&:to_s) }
          .to change { inner_hash }
          .from(c: 2)
          .to(c: '2')
      end
    end

    describe 'Not changing inner hash' do
      it 'changes the original hash' do
        expect { hash.change_values!(skip_inner: false, &:to_s) }
          .to change { hash }
          .from(a: 1, b: { c: 2 })
          .to(a: '1', b: '{c: 2}')
      end

      it 'changes the inner hash' do
        expect { hash.change_values!(skip_inner: false, &:to_s) }
          .not_to(change { inner_hash })
      end
    end
  end
end
