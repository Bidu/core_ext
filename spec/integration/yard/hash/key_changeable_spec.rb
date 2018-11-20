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

    it 'uses the block to change the keys' do
      result = hash.change_keys { |k| (k.to_i + 1).to_s.to_sym }
      expect(result).to eq('2': 1, '3': { '4': 2 })
    end

    it 'uses the block to change the keys' do
      result = hash.change_keys(recursive: false) do |k|
        (k.to_i + 1).to_s.to_sym
      end
      expect(result).to eq('2': 1, '3': { '3' => 2 })
    end
  end

  describe '#chain_change_keys' do
    subject(:hash) { { first: 1, second: 2 } }

    it 'uses the block to change the keys' do
      result = hash.chain_change_keys(:to_s, :size, :to_s, :to_sym)
      expect(result).to eq('5': 1, '6': 2)
    end
  end
end
