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

  describe '#squash' do
    subject(:hash) { { a: { b: { c: 10 } } } }

    it_behaves_like 'a method to squash a hash' do
      let(:squashed) { hash.squash }
    end

    it_behaves_like 'a method to squash a hash', '/' do
      let(:squashed) { hash.squash('/') }
    end

    it 'does not change the hash' do
      expect { hash.squash }
        .not_to(change { hash })
    end
  end

  describe '#squash!' do
    subject(:hash) { { a: { b: { c: 10 } } } }

    it_behaves_like 'a method to squash a hash' do
      let(:squashed) { hash.squash! }
    end

    it_behaves_like 'a method to squash a hash', '/' do
      let(:squashed) { hash.squash!('/') }
    end

    it 'does not change the hash' do
      expect { hash.squash! }
        .to change { hash }
        .from(a: { b: { c: 10 } })
        .to('a.b.c' => 10)
    end
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
        'person.name' => 'John',
        'person.age' => '22'
      }
    end

    it_behaves_like 'a method that returns a deep hash' do
      let(:result) { hash.to_deep_hash(*args) }
    end

    it 'does not change hash' do
      expect { hash.to_deep_hash }
        .not_to(change { hash })
    end
  end

  describe '#to_deep_hash!' do
    subject(:hash) do
      {
        'person.name' => 'John',
        'person.age' => '22'
      }
    end

    it_behaves_like 'a method that returns a deep hash' do
      let(:result) { hash.to_deep_hash!(*args) }
    end

    it 'does changes hash' do
      expect { hash.to_deep_hash! }
        .to change { hash }
        .from('person.name' => 'John', 'person.age' => '22')
        .to('person' => { 'name' => 'John', 'age' => '22' })
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
