# frozen_string_literal: true

require 'spec_helper'

describe Hash::KeyChanger do
  let(:subject) { described_class.new(hash) }

  describe '#underscore_keys' do
    let(:hash) { { keyUnderscore: 1 } }

    it 'underscore all the keys' do
      expect(subject.underscore_keys).to eq(key_underscore: 1)
    end

    context 'when hash is a many level hash' do
      let(:hash) { { keyUnderscore: { anotherKey: 1 } } }

      it 'underscore all the keys' do
        expect(subject.underscore_keys).to eq(key_underscore: { another_key: 1 })
      end
    end

    context 'when hash has an array' do
      let(:hash) { { keyUnderscore: [{ anotherKey: 1 }] } }

      it 'underscore all the keys' do
        expect(subject.underscore_keys).to eq(key_underscore: [{ another_key: 1 }])
      end
    end

    context 'changes the hash' do
      it 'underscore all the keys' do
        expect do
          subject.underscore_keys
        end.to(change { hash })
      end
    end

    context 'when giving non recursive options' do
      context 'when hash is a many level hash' do
        let(:hash) { { keyUnderscore: { anotherKey: 1 } } }

        it 'underscore all the keys' do
          expect(subject.underscore_keys(recursive: false)).to eq(key_underscore: { anotherKey: 1 })
        end
      end

      context 'when hash has an array' do
        let(:hash) { { keyUnderscore: [{ anotherKey: 1 }] } }

        it 'underscore all the keys' do
          expect(subject.underscore_keys(recursive: false)).to eq(key_underscore: [{ anotherKey: 1 }])
        end
      end
    end
  end
end
