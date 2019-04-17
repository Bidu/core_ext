# frozen_string_literal: true

describe Darthjee::CoreExt::Hash::Squasher do
  subject(:squasher) { described_class.new }

  describe '#squash' do
    describe 'Simple Usage' do
      let(:hash) do
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

      let(:expected) do
        {
          'person[0].name[0]' => 'John',
          'person[0].name[1]' => 'Wick',
          'person[0].age'     => 22,
          'person[1].name[0]' => 'John',
          'person[1].name[1]' => 'Constantine',
          'person[1].age'     => 25
        }
      end

      it 'squashes the hash' do
        expect(squasher.squash(hash)).to eq(expected)
      end
    end

    describe 'Passing custom joiner' do
      subject(:squasher) { described_class.new('> ') }

      let(:hash) do
        {
          person: {
            name: 'John',
            age: 22
          }
        }
      end

      let(:expected) do
        {
          'person> name' => 'John',
          'person> age'  => 22
        }
      end

      it 'squashes the hash' do
        expect(squasher.squash(hash)).to eq(expected)
      end
    end
  end
end
