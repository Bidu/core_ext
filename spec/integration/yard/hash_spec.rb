# frozen_string_literal: true

require 'spec_helper'

describe Hash do
  describe 'yard' do
    describe '#chain_fetch' do
      subject(:hash) do
        {
          a: {
            b: { c: 1 }
          }
        }
      end

      context 'when requesting keys that exist' do
        it 'returns the value found' do
          expect(hash.chain_fetch(:a, :b, :c)).to eq(1)
        end
      end

      context 'when key is not found' do
        context 'and no block is given' do
          it do
            expect { hash.chain_fetch(:a, :b, :d) }.to raise_error(KeyError)
          end
        end
        context 'and a block is given' do
          it do
            expect { hash.chain_fetch(:a, :b, :d) { 10 } }.not_to raise_error
          end

          it 'returns the result of the block' do
            result = hash.chain_fetch(:a, :c, :d) { |*args| args }
            expect(result).to eq([:c, [:d]])
          end
        end
      end
    end
  end
end
