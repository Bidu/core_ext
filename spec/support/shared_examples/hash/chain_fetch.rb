# frozen_string_literal: true

shared_examples 'an object with capable of performing chain fetch' do
  describe '#chain_fetch' do
    let(:value) { 10 }
    let(:keys)  { %i[a b c d] }
    let(:block) { nil }
    let(:hash) do
      {
        b: 1, c: 2, d: 3, a: {
          c: 3, d: 5, b: {
            d: 6, a: 1, b: 2, c: {
              d: value
            }
          }
        }
      }
    end

    context 'when fetching existing keys' do
      it 'returns the value' do
        expect(result).to eq(value)
      end
    end

    context 'when fetching non existing keys keys' do
      let(:keys) { %i[a x y] }

      context 'when there is no default value' do
        it 'raises fetch error' do
          expect { result }.to raise_error(KeyError)
        end

        context 'when the hash has no keys' do
          let(:hash) { {} }
          let(:keys) { [:a] }

          it 'raises fetch error' do
            expect { result }.to raise_error(KeyError)
          end
        end

        context 'with a simple level hash' do
          let(:hash) { { a: 1 } }
          let(:keys) { [:c] }

          it 'raises fetch error' do
            expect { result }.to raise_error(KeyError)
          end
        end
      end

      context 'when a default value block is given' do
        let(:default_value) { 100 }
        let(:block) { proc { default_value } }

        it 'returns the default_value' do
          expect(result).to eq(default_value)
        end

        context 'when the block logs the missing keys' do
          it 'hnadles the missing keys' do
            missing_keys = nil
            hash.chain_fetch(*keys) do |_, keys|
              missing_keys = keys
            end

            expect(missing_keys).to eq([:y])
          end
        end

        context 'when the block uses the key for the return' do
          let(:block) { proc { |k| "returned #{k}" } }

          it 'hnadles the missing keys' do
            expect(result).to eq('returned x')
          end
        end
      end
    end

    context 'when mixing key types' do
      let(:hash) { { a: { 'b' => { 100 => { true => value } } } } }
      let(:keys) { [:a, 'b', 100, true] }

      it 'returns the value' do
        expect(result).to eq(value)
      end
    end
  end
end
