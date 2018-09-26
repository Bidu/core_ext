# frozen_string_literal: true

require 'spec_helper'

describe Hash do
  describe 'yard' do
    describe '#exclusive_merge' do
      subject(:hash) { { a: 1, b: 2, c: 3 } }
      let(:other)    { { b: 4, 'c' => 5, e: 6 } }

      it 'merges only the existing keys' do
        expect(hash.exclusive_merge(other)).to eq(a: 1, b: 4, c: 3)
      end

      it 'does not change original hash' do
        expect do
          hash.exclusive_merge(other)
        end.not_to(change { hash })
      end
    end

    describe '#exclusive_merge' do
      subject(:hash) { { a: 1, b: 2, c: 3 } }
      let(:other)    { { b: 4, 'c' => 5, e: 6 } }

      it 'merges only the existing keys' do
        expect(hash.exclusive_merge!(other)).to eq(a: 1, b: 4, c: 3)
      end

      it 'does not change original hash' do
        expect do
          hash.exclusive_merge!(other)
        end.to change { hash }.to(a: 1, b: 4, c: 3)
      end
    end
  end

  describe '#map_to_hash' do
    subject(:hash) { { a: 'word', b: 'bigword', c: 'c' } }

    it 'remaps the values keeping the original keys' do
      new_hash = hash.map_to_hash do |key, value|
        "#{key}->#{value.size}"
      end

      expect(new_hash).to eq(
        a: 'a->4',
        b: 'b->7',
        c: 'c->1'
      )
    end
  end

  describe '#squash' do
    subject(:hash) { { name: { first: 'John', last: 'Doe' } } }

    it 'squash the hash into a one level hash' do
      expect(hash.squash).to eq('name.first' => 'John', 'name.last' => 'Doe')
    end

    context 'when squashing the result of a deep hash' do
      let(:person_data) { { 'person.name' => 'John', 'person.age' => 23 } }
      let(:person) { person_data.to_deep_hash }

      it 'is the reverse operation' do
        expect(person.squash).to eq(person_data)
      end
    end
  end

  describe '#to_deep_hash' do
    subject(:hash) { { 'name_first' => 'John', 'name_last' => 'Doe' } }

    it 'with custom separator' do
      expect(hash.to_deep_hash('_')).to eq(
        'name' => { 'first' => 'John', 'last' => 'Doe' }
      )
    end

    context 'when squashing the result of a deep hash' do
      let(:person) do
        {
          'person' => {
            'name' => 'John',
            'age' => 23
          }
        }
      end
      let(:person_data) { person.squash }

      it 'is the reverse operation' do
        expect(person_data.to_deep_hash).to eq(person)
      end
    end
  end
end
