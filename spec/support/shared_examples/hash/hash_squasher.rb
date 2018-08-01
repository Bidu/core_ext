# frozen_string_literal: true

require 'spec_helper'

shared_examples 'a class that has a method to squash a hash' do
  describe '#squash' do
    let(:hash) { { a: { b: 1, c: { d: 2 } } } }

    it 'flattens the hash' do
      expect(squashed).to eq('a.b' => 1, 'a.c.d' => 2)
    end

    it { expect { hash.squash }.not_to(change { hash }) }

    context 'with array value' do
      let(:hash) { { a: { b: [1, { x: 3, y: { z: 4 } }] } } }

      it 'flattens the hash' do
        expect(squashed).to eq('a.b' => [1, { x: 3, y: { z: 4 } }])
      end
    end
  end
end
