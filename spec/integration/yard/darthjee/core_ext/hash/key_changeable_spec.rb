# frozen_string_literal: true

describe Darthjee::CoreExt::Hash::KeyChangeable do
  describe '#remap_keys' do
    subject(:hash) { { a: 1, b: 2 } }

    it 'remaps the keys' do
      expect(hash.remap_keys(a: :b, b: :c)).to eq(b: 1, c: 2)
    end
  end

  describe '#change_keys' do
    subject(:hash) { { '1' => 1, '2' => { '3' => 2 } } }

    context 'when not passing options' do
      let(:result) do
        hash.change_keys do |k|
          (k.to_i + 1).to_s.to_sym
        end
      end

      it 'uses the block to change the keys' do
        expect(result).to eq('2': 1, '3': { '4': 2 })
      end
    end

    context 'when passing recursive option' do
      let(:result) do
        hash.change_keys(recursive: false) do |k|
          (k.to_i + 1).to_s.to_sym
        end
      end

      it 'uses the block to change the keys' do
        expect(result).to eq('2': 1, '3': { '3' => 2 })
      end
    end
  end

  describe '#chain_change_keys' do
    subject(:hash) { { first: 1, second: 2 } }

    it 'uses the block to change the keys' do
      result = hash.chain_change_keys(:to_s, :size, :to_s, :to_sym)
      expect(result).to eq('5': 1, '6': 2)
    end
  end

  describe '#sort_keys' do
    subject(:hash) { { b: 1, a: 2 } }

    it 'sorts he keys' do
      expect(hash.sort_keys).to eq(a: 2, b: 1)
    end
  end

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
          .to eq(a: '1', b: '{:c=>1}')
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
          .to(a: '1', b: '{:c=>2}')
      end

      it 'changes the inner hash' do
        expect { hash.change_values!(skip_inner: false, &:to_s) }
          .not_to(change { inner_hash })
      end
    end
  end
end
