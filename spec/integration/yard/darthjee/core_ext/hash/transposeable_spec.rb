# frozen_string_literal: true

describe Darthjee::CoreExt::Hash::Transposeable do
  describe 'yard' do
    subject(:hash) do
      {
        key1: :value1,
        key2: :value2,
      }
    end

    describe '#transpose' do
      it 'transpose rows and keys' do
        expect(hash.transpose).to eq({
          value1: :key1,
          value2: :key2
        })
      end

      it do
        expect { hash.transpose }.not_to change { hash }
      end
    end

    describe '#transpose' do
      it 'transpose rows and keys' do
        expect { hash.transpose! }.to change { hash }
          .to(
            value1: :key1,
            value2: :key2
        )
      end
    end
  end
end
