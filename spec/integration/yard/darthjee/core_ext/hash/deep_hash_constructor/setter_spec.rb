# frozen_string_literal: true

describe Darthjee::CoreExt::Hash::DeepHashConstructor::Setter do
  subject(:setter) { described_class.new(hash, base_key) }

  let(:hash)  { {} }
  let(:value) { 21 }

  describe 'yard' do
    describe 'Simple usage' do
      let(:base_key) { 'person' }
      let(:key)      { 'age' }

      it 'set value on inner hash' do
        expect { setter.set(key, value) }
          .to change { hash }
          .from({})
          .to(base_key => { key => value })
      end
    end

    describe 'with array index' do
      let(:base_key) { 'person[0]' }
      let(:key)      { nil }

      it 'set value on base key array' do
        expect { setter.set(key, value) }
          .to change { hash }
          .from({})
          .to('person' => [value])
      end
    end
  end
end
