# frozen_string_literal: true

require 'spec_helper'

describe Darthjee::CoreExt::Hash::DeepHashConstructor do
  describe 'yard' do
    describe 'general usage' do
      subject(:constructor) { described_class.new('.') }

      let(:hash) do
        {
          'person.name'   => 'John',
          'person.age'    =>  20,
          :'house.number' => 67,
          :'house.zip'    => 12_345
        }
      end

      let(:expected) do
        {
          'person' => {
            'name'   => 'John',
            'age'    =>  20
          },
          'house' => {
            'number' => 67,
            'zip'    => 12_345
          }
        }
      end

      it 'builds deep hash' do
        expect(constructor.deep_hash(hash))
          .to eq(expected)
      end
    end
  end
end
