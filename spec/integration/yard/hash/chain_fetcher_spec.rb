# frozen_string_literal: true

describe Darthjee::CoreExt::Hash::ChainFetcher do
  let(:hash) do
    {
      a: {
        b: { c: 1, d: 2 }
      }
    }
  end

  context 'when not giving a block' do
    subject(:fetcher) do
      described_class.new(hash, *keys)
    end

    context 'when keys are found' do
      let(:keys) { %i[a b c] }

      it 'returns the value found' do
        expect(fetcher.fetch).to eq(1)
      end
    end

    context 'when key is not found' do
      let(:keys) { %i[a c d] }

      it do
        expect { fetcher.fetch }.to raise_error(KeyError)
      end
    end
  end

  context 'when giving a block' do
    subject(:fetcher) do
      described_class.new(hash, *keys) { |*args| args }
    end

    context 'and keys are not found' do
      let(:keys) { %i[a c d] }

      it do
        expect { fetcher.fetch }.not_to raise_error
      end

      it 'returns the result of the block' do
        expect(fetcher.fetch).to eq([:c, [:d]])
      end
    end
  end
end
