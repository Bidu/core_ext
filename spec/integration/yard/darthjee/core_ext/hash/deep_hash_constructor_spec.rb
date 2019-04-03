# frozen_string_literal: true

require 'spec_helper'

describe Darthjee::CoreExt::Hash::DeepHashConstructor do
  describe 'yard' do
    subject(:constructor) { described_class.new('.') }

    let(:hash) do
      {
        'account.person.name' => 'John',
        'account.person.age'  =>  20,
        'account.number'      => '102030',
        :'house.number'       => 67,
        :'house.zip'          => 12_345
      }
    end

    describe 'general usage' do
      let(:expected) do
        {
          'account' => {
            'person' => {
              'name'   => 'John',
              'age'    =>  20
            },
            'number' => '102030'
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

    describe '#break_keys' do
      let(:expected) do
        {
          'account' => {
            %w[person name] => 'John',
            %w[person age]  =>  20,
            %w[number]      => '102030'
          },
          'house' => {
            %w[number] => 67,
            %w[zip]    => 12_345
          }
        }
      end

      it 'builds deep hash' do
        expect(constructor.send(:break_keys, hash))
          .to eq(expected)
      end
    end
  end
end
