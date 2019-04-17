# frozen_string_literal: true

require 'spec_helper'

shared_examples 'a method to squash a hash' do |joiner = '.'|
  let(:hash) { { a: { b: 1, c: { d: 2 } } } }

  context 'with hash values' do
    let(:key1) { %w[a b].join(joiner) }
    let(:key2) { %w[a c d].join(joiner) }

    it 'flattens the hash' do
      expect(squashed).to eq(key1 => 1, key2 => 2)
    end

    it { expect { hash.squash }.not_to(change { hash }) }
  end

  context 'with simple array value' do
    let(:hash) do
      {
        'person' => %w[John Wick]
      }
    end

    it 'squash also hash' do
      expect(squashed).to eq(
        'person[0]' => 'John',
        'person[1]' => 'Wick'
      )
    end
  end

  context 'with array containing hashes' do
    let(:hash) { { a: { b: [1, { x: 3, y: { z: 4 } }] } } }
    let(:key)  { %w[a b].join(joiner) }

    let(:expected) do
      {
        "#{key}[0]" => 1,
        "#{key}[1]#{joiner}x" => 3,
        "#{key}[1]#{joiner}y#{joiner}z" => 4
      }
    end

    it 'flattens the hash' do
      expect(squashed).to eq(expected)
    end
  end

  context 'with array containing arrays' do
    let(:hash) { { a: { b: [[11, 12], [21, 22]] } } }
    let(:key)  { %w[a b].join(joiner) }

    let(:expected) do
      {
        "#{key}[0][0]" => 11,
        "#{key}[0][1]" => 12,
        "#{key}[1][0]" => 21,
        "#{key}[1][1]" => 22
      }
    end

    it 'flattens the hash' do
      expect(squashed).to eq(expected)
    end
  end
end
