# frozen_string_literal: true

shared_examples 'a class with a keys sort method' do
  describe '#sort_keys' do
    let(:options) { {} }

    context 'when keys are symbols' do
      let(:hash) { { b: 1, a: 2 } }

      it 'sorts keys as symbols' do
        expect(result).to eq(a: 2, b: 1)
      end
    end

    context 'when keys are strings' do
      let(:hash) { { 'b' => 1, 'a' => 2 } }

      it 'sorts keys as string' do
        expect(result).to eq('a' => 2, 'b' => 1)
      end
    end

    context 'when there is a nested hash' do
      let(:hash) { { b: 1, a: { d: 3, c: 4 } } }

      context 'and no option is given' do
        it 'sorts keys recursively' do
          expect(result).to eq(a: { c: 4, d: 3 }, b: 1)
        end
      end
      
      context 'and recursive option is given' do
        let(:options) { { recursive: true } }

        it 'sorts keys recursively when argumen is passed' do
          expect(result).to eq(a: { c: 4, d: 3 }, b: 1)
        end
      end
      
      context 'and no recursive option is given' do
        let(:options) { { recursive: false } }

        it 'does not sorts keys recursively when argumen is passed' do
          expect(result).to eq(a: { d: 3, c: 4 }, b: 1)
        end
      end
    end

    context 'when it is deep nestled' do
      let(:hash) { { b: 1, a: { d: 2, c: { e: 3, f: 4 } } } }

      it 'sort recursevely on many levels' do
        expected = { a: { c: { f: 4, e: 3 }, d: 2 }, b: 1 }
        expect(hash.sort_keys(recursive: true)).to eq(expected)
      end
    end

    context 'when it has a nestled array' do
      let(:hash) { { b: 1, a: { d: 2, c: [{ e: 3, f: 4 }] } } }

      it 'applies to arrays as well' do
        expected = { a: { c: [{ f: 4, e: 3 }], d: 2 }, b: 1 }
        expect(hash.sort_keys(recursive: true)).to eq(expected)
      end
    end
  end
end
