# frozen_string_literal: true

require 'spec_helper'

describe Darthjee::CoreExt::Hash::DeepHashConstructor do
  subject(:constructor) { described_class.new('.') }

  let(:hash) do
    {
      'person.name' => 'John',
      'person.age' => '22'
    }
  end

  describe '#deep_hash' do
    it_behaves_like 'a method that returns a deep hash' do
      subject(:constructor) { described_class.new(*args) }

      let(:result) { constructor.deep_hash(hash) }
    end

    it 'does changes hash' do
      expect { constructor.deep_hash(hash) }
        .to change { hash }
        .from('person.name' => 'John', 'person.age' => '22')
        .to('person' => { 'name' => 'John', 'age' => '22' })
    end
  end
end
