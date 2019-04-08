# frozen_string_literal: true

require 'spec_helper'

describe Darthjee::CoreExt::Hash::KeyChanger do
  describe 'yard' do
    subject(:changer) { described_class.new(hash) }

    describe '#remap' do
      let(:hash) { { a: 1, 'b' => 2 } }

      let(:remap_map) { { a: :za, b: :zb, 'b' => 'yb' } }

      it 'changes keys using the map' do
        expect { changer.remap(remap_map) }
          .to change { hash }.to(za: 1, 'yb' => 2, zb: nil)
      end
    end

    describe '#change_keys' do
      let(:hash) { { a: 1, 'b' => { c: 3 } } }
      let(:expected) do
        { 'key_a' => 1, 'key_b' => { 'key_c' => 3 } }
      end

      it 'changes keys using block' do
        expect { changer.change_keys { |k| "key_#{k}" } }
          .to change { hash }.to(expected)
      end
    end

    describe '#camelize_keys' do
      let(:hash) { { my_key: { inner_key: 10 } } }

      it 'camelizes all keys' do
        expect { changer.camelize_keys }
          .to change { hash }.to(MyKey: { InnerKey: 10 })
      end
    end

    describe '#underscore_keys' do
      let(:hash) { { myKey: { InnerKey: 10 } } }

      it 'camelizes all keys' do
        expect { changer.underscore_keys }
          .to change { hash }.to(my_key: { inner_key: 10 })
      end
    end

    describe '#change_text' do
      let(:hash) { { key: { inner_key: 10 } } }

      it 'changes the text of the keys' do
        expect { changer.change_text { |key| key.to_s.upcase } }
          .to change { hash }.to(KEY: { INNER_KEY: 10 })
      end
    end
  end
end
