# frozen_string_literal: true

require 'spec_helper'

describe Darthjee::CoreExt::Hash::DeepHashConstructor::Setter do
  subject(:setter) { described_class.new(hash, base_key) }

  let(:hash)  { {} }
  let(:value) { 21 }

  describe '#set' do
    context 'when base_key does not have index' do
      let(:base_key) { 'person' }

      context 'when key is nil' do
        let(:key) { nil }

        it 'set value on base key' do
          expect { setter.set(key, value) }
            .to change { hash }
            .from({})
            .to(base_key => value)
        end
      end

      context 'when key is present' do
        let(:key) { 'age' }

        it 'set value on inner hash' do
          expect { setter.set(key, value) }
            .to change { hash }
            .from({})
            .to(base_key => { key => value })
        end
      end
    end

    context 'when base_key has index' do
      let(:base_key) { 'person[0]' }

      context 'when key is nil' do
        let(:key) { nil }

        it 'set value on base key array' do
          expect { setter.set(key, value) }
            .to change { hash }
            .from({})
            .to('person' => [value])
        end
      end

      context 'when key is present' do
        let(:key) { 'age' }

        it 'set value on inner hash inside array' do
          expect { setter.set(key, value) }
            .to change { hash }
            .from({})
            .to('person' => [{ key => value }])
        end
      end
    end
  end
end
