# frozen_string_literal: true

describe Darthjee::CoreExt::Hash::KeyChangeable do
  describe '#remap_keys' do
    subject(:hash) { { a: 1, b: 2 } }

    it "remaps the keys" do
      expect(hash.remap_keys(a: :b, b: :c)).to eq(b: 1, c: 2)
    end
  end
end
