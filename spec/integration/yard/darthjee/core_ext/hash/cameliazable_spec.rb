# frozen_string_literal: true

describe Darthjee::CoreExt::Hash::Cameliazable do
  describe 'camlize_keys' do
    subject(:hash) do
      { first_key: 1, 'second_key' => 2 }
    end

    context 'when no option is given' do
      it 'camelize all keys' do
        result = hash.camelize_keys
        expect(result).to eq(FirstKey: 1, 'SecondKey' => 2)
      end
    end

    context 'when passing uppercase_first_letter option' do
      it 'camelize all keys' do
        result = hash.camelize_keys(uppercase_first_letter: false)
        expect(result).to eq(firstKey: 1, 'secondKey' => 2)
      end
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

  describe '#underscore_keys' do
    subject(:hash) do
      { firstKey: 1, 'SecondKey' => 2 }
    end

    it 'camelize all keys' do
      result = hash.underscore_keys
      expect(result).to eq(first_key: 1, 'second_key' => 2)
    end
  end
end
