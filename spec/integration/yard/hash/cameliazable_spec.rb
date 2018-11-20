# frozen_string_literal: true

describe Darthjee::CoreExt::Hash::Cameliazable do
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
