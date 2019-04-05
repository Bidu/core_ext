# frozen_string_literal: true

require 'spec_helper'

describe Hash do
  describe 'yard' do
    describe '#chain_fetch' do
      subject(:hash) do
        {
          a: {
            b: { c: 1, d: 2 }
          }
        }
      end

      context 'when requesting keys that exist' do
        it 'returns the value found' do
          expect(hash.chain_fetch(:a, :b, :c)).to eq(1)
        end
      end

      context 'when key is not found' do
        context 'when no block is given' do
          it do
            expect { hash.chain_fetch(:a, :c, :d) }
              .to raise_error(KeyError)
          end
        end

        context 'when a block is given' do
          it do
            expect { hash.chain_fetch(:a, :c, :d) { 10 } }
              .not_to raise_error
          end

          it 'returns the result of the block' do
            result = hash.chain_fetch(:a, :c, :d) { |*args| args }
            expect(result).to eq([:c, [:d]])
          end
        end
      end

      describe '#append_to_keys' do
        let(:hash) { { :a => 1, 'b' => 2 } }

        it 'appends string to keys' do
          expect(hash.prepend_to_keys('foo_'))
            .to eq(:foo_a => 1, 'foo_b' => 2)
        end
      end
    end
  end
end
