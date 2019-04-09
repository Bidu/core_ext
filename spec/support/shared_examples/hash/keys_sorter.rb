# frozen_string_literal: true

shared_examples 'a class with a keys sort method' do
  describe '#sort_keys' do
    let(:options) { {} }

    context 'when keys are symbols' do
      let(:hash) { { b: 1, a: 2 } }

      it 'sorts keys as symbols' do
        expect(result).to eq(a: 2, b: 1)
      end

      it 'sorts keys' do
        expect(result.keys).to eq(%i[a b])
      end
    end

    context 'when keys are strings' do
      let(:hash) { { 'b' => 1, 'a' => 2 } }

      it 'sorts keys as string' do
        expect(result).to eq('a' => 2, 'b' => 1)
      end

      it 'sorts keys' do
        expect(result.keys).to eq(%w[a b])
      end
    end

    context 'when there is a nested hash' do
      let(:hash) { { b: 1, a: { d: 3, c: 4 } } }

      context 'when no option is given' do
        it 'sorts keys recursively' do
          expect(result).to eq(a: { c: 4, d: 3 }, b: 1)
        end

        it 'sorts keys' do
          expect(result.keys).to eq(%i[a b])
        end

        it 'sorts inner keys' do
          expect(result[:a].keys).to eq(%i[c d])
        end
      end

      context 'when recursive option is given' do
        let(:options) { { recursive: true } }

        it 'sorts keys recursively when argumen is passed' do
          expect(result).to eq(a: { c: 4, d: 3 }, b: 1)
        end

        it 'sorts keys' do
          expect(result.keys).to eq(%i[a b])
        end

        it 'sorts inner keys' do
          expect(result[:a].keys).to eq(%i[c d])
        end
      end

      context 'when no recursive option is given' do
        let(:options) { { recursive: false } }

        it 'does not sorts keys recursively when argumen is passed' do
          expect(result).to eq(a: { d: 3, c: 4 }, b: 1)
        end

        it 'sorts keys' do
          expect(result.keys).to eq(%i[a b])
        end

        it 'does not sort inner keys' do
          expect(result[:a].keys).to eq(%i[d c])
        end

        it 'does not change inner hash' do
          expect { result }.not_to change(hash[:a], :keys)
        end
      end
    end

    context 'when it is deep nestled' do
      let(:hash) { { b: 1, a: { d: 2, c: { f: 3, e: 4 } } } }

      it 'sort recursevely on many levels' do
        expected = { a: { c: { f: 3, e: 4 }, d: 2 }, b: 1 }
        expect(result).to eq(expected)
      end

      it 'sorts keys' do
        expect(result.keys).to eq(%i[a b])
      end

      it 'sorts inner keys' do
        expect(result[:a].keys).to eq(%i[c d])
      end

      it 'sorts deeper inner keys' do
        expect(result[:a][:c].keys).to eq(%i[e f])
      end
    end

    context 'when it has a nestled array' do
      let(:hash) { { b: 1, a: { d: 2, c: [{ f: 3, e: 4 }] } } }

      it 'applies to arrays as well' do
        expected = { a: { c: [{ f: 3, e: 4 }], d: 2 }, b: 1 }
        expect(result).to eq(expected)
      end

      it 'sorts keys' do
        expect(result.keys).to eq(%i[a b])
      end

      it 'sorts inner keys' do
        expect(result[:a].keys).to eq(%i[c d])
      end

      it 'does not sort array deeper inner keys' do
        expect(result[:a][:c].map(&:keys)).to eq([%i[f e]])
      end

      it 'does not change array deeper inner hash' do
        expect { result }.not_to(change { hash[:a][:c].map(&:keys) })
      end
    end
  end
end

shared_examples 'a class with a keys sort method that changes original' do
  describe '#sort_keys' do
    let(:options) { {} }

    context 'when keys are symbols' do
      let(:hash) { { b: 1, a: 2 } }

      it 'changes original hash' do
        expect { result }.to change(hash, :keys)
          .from(%i[b a]).to(%i[a b])
      end
    end

    context 'when keys are strings' do
      let(:hash) { { 'b' => 1, 'a' => 2 } }

      it 'changes original hash' do
        expect { result }.to change(hash, :keys)
          .from(%w[b a]).to(%w[a b])
      end
    end

    context 'when there is a nested hash' do
      let(:hash) { { b: 1, a: { d: 3, c: 4 } } }

      context 'when no option is given' do
        it 'changes original hash' do
          expect { result }.to change(hash, :keys)
            .from(%i[b a]).to(%i[a b])
        end

        it 'changes inner hash' do
          expect { result }.to change(hash[:a], :keys)
            .from(%i[d c]).to(%i[c d])
        end
      end

      context 'when recursive option is given' do
        let(:options) { { recursive: true } }

        it 'changes original hash' do
          expect { result }.to change(hash, :keys)
            .from(%i[b a]).to(%i[a b])
        end

        it 'changes inner hash' do
          expect { result }.to change(hash[:a], :keys)
            .from(%i[d c]).to(%i[c d])
        end
      end

      context 'when no recursive option is given' do
        let(:options) { { recursive: false } }

        it 'changes original hash' do
          expect { result }.to change(hash, :keys)
            .from(%i[b a]).to(%i[a b])
        end

        it 'does not change inner hash' do
          expect { result }.not_to change(hash[:a], :keys)
        end
      end
    end

    context 'when it is deep nestled' do
      let(:hash) { { b: 1, a: { d: 2, c: { f: 3, e: 4 } } } }

      it 'changes original hash' do
        expect { result }.to change(hash, :keys)
          .from(%i[b a]).to(%i[a b])
      end

      it 'changes inner hash' do
        expect { result }.to change(hash[:a], :keys)
          .from(%i[d c]).to(%i[c d])
      end

      it 'changes deeper inner hash' do
        expect { result }.to change(hash[:a][:c], :keys)
          .from(%i[f e]).to(%i[e f])
      end
    end

    context 'when it has a nestled array' do
      let(:hash) { { b: 1, a: { d: 2, c: [{ f: 3, e: 4 }] } } }

      it 'changes original hash' do
        expect { result }.to change(hash, :keys)
          .from(%i[b a]).to(%i[a b])
      end

      it 'changes inner hash' do
        expect { result }.to change(hash[:a], :keys)
          .from(%i[d c]).to(%i[c d])
      end

      it 'does not change array deeper inner hash' do
        expect { result }.not_to(change { hash[:a][:c].map(&:keys) })
      end
    end
  end
end

shared_examples 'a class with a keys sort method that not change self' do
  describe '#sort_keys' do
    let(:options) { {} }

    context 'when keys are symbols' do
      let(:hash) { { b: 1, a: 2 } }

      it 'changes original hash' do
        expect { result }.not_to change(hash, :keys)
      end
    end

    context 'when keys are strings' do
      let(:hash) { { 'b' => 1, 'a' => 2 } }

      it 'changes original hash' do
        expect { result }.not_to change(hash, :keys)
      end
    end

    context 'when there is a nested hash' do
      let(:hash) { { b: 1, a: { d: 3, c: 4 } } }

      context 'when no option is given' do
        it 'changes original hash' do
          expect { result }.not_to change(hash, :keys)
        end

        it 'changes inner hash' do
          expect { result }.not_to change(hash[:a], :keys)
        end
      end

      context 'when recursive option is given' do
        let(:options) { { recursive: true } }

        it 'changes original hash' do
          expect { result }.not_to change(hash, :keys)
        end

        it 'changes inner hash' do
          expect { result }.not_to change(hash[:a], :keys)
        end
      end

      context 'when no recursive option is given' do
        let(:options) { { recursive: false } }

        it 'changes original hash' do
          expect { result }.not_to change(hash, :keys)
        end

        it 'does not change inner hash' do
          expect { result }.not_to change(hash[:a], :keys)
        end
      end
    end

    context 'when it is deep nestled' do
      let(:hash) { { b: 1, a: { d: 2, c: { f: 3, e: 4 } } } }

      it 'changes original hash' do
        expect { result }.not_to change(hash, :keys)
      end

      it 'changes inner hash' do
        expect { result }.not_to change(hash[:a], :keys)
      end

      it 'changes deeper inner hash' do
        expect { result }.not_to change(hash[:a][:c], :keys)
      end
    end

    context 'when it has a nestled array' do
      let(:hash) { { b: 1, a: { d: 2, c: [{ f: 3, e: 4 }] } } }

      it 'changes original hash' do
        expect { result }.not_to change(hash, :keys)
      end

      it 'changes inner hash' do
        expect { result }.not_to change(hash[:a], :keys)
      end

      it 'does not change array deeper inner hash' do
        expect { result }.not_to(change { hash[:a][:c].map(&:keys) })
      end
    end
  end
end
