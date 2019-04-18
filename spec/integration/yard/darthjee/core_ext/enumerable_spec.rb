# frozen_string_literal: true

require 'spec_helper'

describe Enumerable do
  describe 'yard' do
    describe '#clean!' do
      context 'when subject is a hash' do
        subject(:hash) do
          {
            keep: 'value',
            nil_value: nil,
            empty_array: [],
            empty_string: '',
            empty_hash: {}
          }
        end

        it 'removes empty values' do
          expect { hash.clean! }.to change { hash }.to(keep: 'value')
        end
      end

      context 'when subject is an array' do
        subject(:array) do
          ['value', nil, [], '', {}]
        end

        it 'removes empty values' do
          expect { array.clean! }.to change { array }.to(['value'])
        end
      end
    end

    describe '#map_and_find' do
      subject(:keys) { %i[a b c d e] }

      let(:service_values) do
        {
          a: nil,
          b: false,
          c: 'found me',
          d: nil,
          e: 'didnt find me'
        }
      end

      it 'returns the first non false value' do
        value = keys.map_and_find { |key| service_values.delete(key) }
        expect(value).to eq('found me')
      end

      it 'stops running when value is found' do
        expect do
          keys.map_and_find { |key| service_values.delete(key) }
        end.to change { service_values }.to(d: nil, e: 'didnt find me')
      end
    end

    describe '#map_and_select' do
      subject(:hash) do
        {
          a: nil,
          b: 'aka',
          c: 'a'
        }
      end

      it 'returns the first non false value' do
        array = hash.map_and_select { |_key, value| value&.size }
        expect(array).to eq([3, 1])
      end
    end

    describe 'map_to_hash' do
      describe 'Mapping strings to their sizes' do
        subject(:strings) { %w[word big_word] }

        it 'returns a hash with the mapped values' do
          hash = strings.map_to_hash(&:size)
          expect(hash).to eq('word' => 4, 'big_word' => 8)
        end
      end

      describe 'Mapping a hash' do
        subject(:hash) { { a: 'word', b: 'bigword', c: 'c' } }

        let(:new_hash) do
          hash.map_to_hash do |key, value|
            "#{key}->#{value.size}"
          end
        end

        it 'remaps the values keeping the original keys' do
          expect(new_hash).to eq(
            a: 'a->4',
            b: 'b->7',
            c: 'c->1'
          )
        end
      end
    end
  end
end
