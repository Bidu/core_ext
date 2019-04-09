# frozen_string_literal: true

require 'spec_helper'

describe Hash do
  it_behaves_like 'a class with change_key method'
  it_behaves_like 'a class with chain_change_key method'
  it_behaves_like 'a class with camlize_keys method'
  it_behaves_like 'a class with underscore_keys method'
  it_behaves_like 'a class with append_keys method'
  it_behaves_like 'a class with change_values method'
  it_behaves_like 'a class with remap method'
  it_behaves_like 'a class with transpose methods'

  it_behaves_like 'an object with capable of performing chain fetch' do
    let(:result) { hash.chain_fetch(*keys, &block) }
  end

  it_behaves_like 'a class that has a method to squash a hash' do
    let(:squashed) { hash.squash }
  end

  it_behaves_like 'a hash with map_to_hash method' do
    let(:mapped) { hash.map_to_hash(&mapping_block) }
  end

  describe '#sort_keys!' do
    it_behaves_like 'a class with a keys sort method' do
      let(:result) { hash.sort_keys!(**options) }
    end

    it_behaves_like 'a class with a keys sort method that changes original' do
      let(:result) { hash.sort_keys!(**options) }
    end
  end

  describe '#sort_keys' do
    it_behaves_like 'a class with a keys sort method' do
      let(:result) { hash.sort_keys(**options) }
    end

    it_behaves_like 'a class with a keys sort method that not change self' do
      let(:result) { hash.sort_keys(**options) }
    end
  end

  describe '#exclusive_merge' do
    subject(:hash) { { a: 1, b: 2 } }

    let(:other) { { b: 3, c: 4 } }

    it 'merge only the common keys' do
      expect(hash.exclusive_merge(other)).to eq(a: 1, b: 3)
    end

    it 'does not change the original hash' do
      expect { hash.exclusive_merge(other) }.not_to(change { hash })
    end
  end

  describe '#exclusive_merge!' do
    subject(:hash) { { a: 1, b: 2 } }

    let(:other) { { b: 3, c: 4 } }

    it 'merge only the common keys' do
      expect(hash.exclusive_merge!(other)).to eq(a: 1, b: 3)
    end

    it 'does not change the original hash' do
      expect { hash.exclusive_merge!(other) }.to(change { hash })
    end
  end

  describe '#to_deep_hash' do
    subject(:hash) do
      {
        'person.name' => 'Some name',
        'person.age' => 22,
        'status' => :success,
        'vehicle.fuel' => 'GASOLINE',
        'vehicle.doors' => 4
      }
    end

    let(:expected) do
      {
        'person' => { 'name' => 'Some name', 'age' => 22 },
        'vehicle' => { 'fuel' => 'GASOLINE', 'doors' => 4 },
        'status' => :success
      }
    end

    it 'build a deep hash' do
      expect(hash.to_deep_hash).to eq(expected)
    end

    context 'with indexed keys' do
      subject(:hash) do
        {
          'person[0].name' => 'First person',
          'person[0].age' => 22,
          'person[1].name' => 'Second person',
          'person[1].age' => 27,
          'device[0]' => 'GEAR_LOCK',
          'device[1]' => 'GPS',
          'zipCode' => '122345-123'
        }
      end

      let(:expected) do
        {
          'person' => [
            { 'name' => 'First person', 'age' => 22 },
            { 'name' => 'Second person', 'age' => 27 }
          ],
          'device' => %w[GEAR_LOCK GPS],
          'zipCode' => '122345-123'
        }
      end

      it 'build a deep hash with arrays' do
        expect(hash.to_deep_hash).to eq(expected)
      end
    end

    context 'with a n level hash' do
      subject(:hash) do
        {
          'quote_request.personal.person.name' => 'Some name',
          'quote_request.personal.person.age' => 22,
          'quote_request.insurance.vehicle.fuel' => 'GASOLINE',
          'quote_request.insurance.vehicle.doors' => 4,
          'request.status' => :success,
          'trials' => 3
        }
      end

      let(:expected) do
        {
          'quote_request' => {
            'personal' => {
              'person' => { 'name' => 'Some name', 'age' => 22 }
            },
            'insurance' => {
              'vehicle' => { 'fuel' => 'GASOLINE', 'doors' => 4 }
            }
          },
          'request' => { 'status' => :success },
          'trials' => 3
        }
      end

      it 'build a deep hash with arrays' do
        expect(hash.to_deep_hash).to eq(expected)
      end
    end

    context 'with a n level hash and arrays' do
      subject(:hash) do
        {
          'quote_request.personal.person[0].name' => 'Some name 1',
          'quote_request.personal.person[0].age' => 22,
          'quote_request.personal.person[1].name' => 'Some name 2',
          'quote_request.personal.person[1].age' => 23,
          'request[0].status.clazz' => String,
          'request[1].status.clazz' => Integer,
          'request[2].status.clazz' => Date,
          'trials' => 3
        }
      end

      let(:expected) do
        {
          'quote_request' => {
            'personal' => {
              'person' => [
                { 'name' => 'Some name 1', 'age' => 22 },
                { 'name' => 'Some name 2', 'age' => 23 }
              ]
            }
          },
          'request' => [
            { 'status' => { 'clazz' => String } },
            { 'status' => { 'clazz' => Integer } },
            { 'status' => { 'clazz' => Date } }
          ],
          'trials' => 3
        }
      end

      it 'build a deep hash with arrays' do
        expect(hash.to_deep_hash).to eq(expected)
      end
    end

    context 'with custom separator' do
      subject(:hash) do
        {
          'person_name' => 'Some name',
          'person_age' => 22,
          'status' => :success,
          'vehicle_fuel' => 'GASOLINE',
          'vehicle_doors' => 4
        }
      end

      it 'build a deep hash with arrays' do
        expect(hash.to_deep_hash('_')).to eq(expected)
      end
    end

    context 'with custom separator on n level deep hash' do
      subject(:hash) do
        {
          'person_name_clazz' => String
        }
      end

      let(:expected) do
        {
          'person' => {
            'name' => { 'clazz' => String }
          }
        }
      end

      it 'build a deep hash with arrays' do
        expect(hash.to_deep_hash('_')).to eq(expected)
      end
    end
  end

  describe '#map_and_find' do
    let(:hash)  { { a: 1, b: 2, c: 3, d: 4 } }
    let(:value) { hash.map_and_find(&block) }

    context 'when block returns nil' do
      let(:block) { proc {} }

      it { expect(value).to be_nil }
    end

    context 'when block returns false' do
      let(:block) { proc { false } }

      it { expect(value).to be_nil }
    end

    context 'when block returns a true evaluated value' do
      let(:block) { proc { |_, v| v.to_s } }

      it { expect(value).to eq('1') }

      context 'when block returns the key and not the value' do
        let(:block) { proc { |k, v| v > 1 && k } }

        it { expect(value).to eq(:b) }
      end

      context 'when first value returns nothing' do
        let(:block) { proc { |_, v| transformer.transform(v) } }

        let(:transformer) do
          DummyTransformer.new do |value|
            value.to_s if value > 1
          end
        end

        before do
          allow(transformer).to receive(:transform).and_call_original
          value
        end

        it { expect(value).to eq('2') }

        it 'calls the mapping only until it returns a valid value' do
          expect(transformer).to have_received(:transform).exactly(2)
        end
      end
    end

    context 'when the block accepts one argument' do
      let(:block) { proc { |v| v } }

      it do
        expect(value).to eq([:a, 1])
      end
    end
  end

  describe '#map_and_select' do
    let(:hash) { { a: 1, b: 2, c: 3, d: 4 } }
    let(:list) { hash.map_and_select(&block) }

    context 'when block returns nil' do
      let(:block) { proc {} }

      it { expect(list).to be_empty }
    end

    context 'when block returns false' do
      let(:block) { proc { false } }

      it { expect(list).to be_empty }
    end

    context 'when block returns a true evaluated value' do
      let(:block) { proc { |_, v| v.to_s } }

      it { expect(list).to eq((1..4).map(&:to_s)) }

      context 'when block returns the key and not the value' do
        let(:block) { proc { |k, v| v > 1 && k } }

        it { expect(list).to eq(%i[b c d]) }
      end

      context 'when first value does not return a value' do
        let(:block) { proc { |_, v| transformer.transform(v) } }

        let(:transformer) do
          DummyTransformer.new do |value|
            value.to_s if value > 1
          end
        end

        before do
          allow(transformer).to receive(:transform).and_call_original
          list
        end

        it { expect(list).to eq(hash.values[1..-1].map(&:to_s)) }
        it 'calls the mapping only once for each value' do
          expect(transformer).to have_received(:transform).exactly(4)
        end
      end
    end

    context 'when the block accepts one argument' do
      let(:block) { proc { |v| v } }

      it do
        expect(list).to eq([[:a, 1], [:b, 2], [:c, 3], [:d, 4]])
      end
    end
  end
end
