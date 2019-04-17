# frozen_string_literal: true

require 'spec_helper'

describe Hash do
  describe 'yard' do
    describe '#exclusive_merge' do
      subject(:hash) { { a: 1, b: 2, c: 3 } }

      let(:other)    { { b: 4, 'c' => 5, e: 6 } }

      it 'merges only the existing keys' do
        expect(hash.exclusive_merge(other))
          .to eq(a: 1, b: 4, c: 3)
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
        expect(hash.exclusive_merge!(other))
          .to eq(a: 1, b: 4, c: 3)
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

  describe '#squash' do
    describe 'Simple Usage' do
      subject(:hash) do
        { name: { first: 'John', last: 'Doe' } }
      end

      it 'squash the hash into a one level hash' do
        expect(hash.squash)
          .to eq('name.first' => 'John', 'name.last' => 'Doe')
      end
    end

    describe 'Reverting a #to_deep_hash call' do
      let(:person) { person_data.to_deep_hash }
      let(:person_data) do
        { 'person.name' => 'John', 'person.age' => 23 }
      end

      it 'is the reverse operation' do
        expect(person.squash).to eq(person_data)
      end
    end

    describe 'Giving a custom joiner' do
      subject(:hash) do
        {
          links: {
            home: '/',
            products: '/products'
          }
        }
      end

      it 'joins keys using custom joiner' do
        expect(hash.squash('> ')).to eq(
          'links> home' => '/',
          'links> products' => '/products'
        )
      end
    end
  end

  describe '#to_deep_hash' do
    describe 'With custom separator' do
      subject(:hash) do
        {
          'person[0]_name_first' => 'John',
          'person[0]_name_last'  => 'Doe',
          'person[1]_name_first' => 'John',
          'person[1]_name_last'  => 'Wick'
        }
      end

      let(:expected) do
        {
          'person' => [{
            'name' => { 'first' => 'John', 'last' => 'Doe' }
          }, {
            'name' => { 'first' => 'John', 'last' => 'Wick' }
          }]
        }
      end

      it 'with custom separator' do
        expect(hash.to_deep_hash('_')).to eq(expected)
      end
    end

    describe 'Reverting the result of a squash' do
      let(:person) do
        {
          person: [{
            name: %w[John Wick],
            age: 22
          }, {
            name: %w[John Constantine],
            age: 25
          }]
        }
      end
      let(:person_data) { person.squash }

      it 'is the reverse operation' do
        expect(person_data.to_deep_hash)
          .to eq(person.deep_stringify_keys)
      end
    end
  end
end
