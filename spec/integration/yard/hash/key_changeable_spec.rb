# frozen_string_literal: true

describe Darthjee::CoreExt::Hash::KeyChangeable do
  describe '#remap_keys' do
    subject(:hash) { { a: 1, b: 2 } }

    it "remaps the keys" do
      expect(hash.remap_keys(a: :b, b: :c)).to eq(b: 1, c: 2)
    end
  end

  describe '#lower_camelize_keys' do
    subject(:hash) do
      { first_key: 1, 'second_key' => 2 }
    end

    it 'camelize all keys' do
      result = hash.lower_camelize_keys
      expect(result).to eq(firstKey: 1, 'secondKey' => 2)
    end
  end
end
