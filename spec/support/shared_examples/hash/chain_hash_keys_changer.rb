# frozen_string_literal: true

shared_examples 'a class with chain_change_key method' do
  let(:hash) do
    { 'a' => 1, b: 2, c: { d: 3, e: 4 }, f: [{ g: 5 }, { h: 6 }] }
  end

  describe '#chain_change_keys' do
    it_behaves_like 'a method that is able to chain change keys',
                    :chain_change_keys
    it 'does not affects the original hash' do
      expect do
        hash.chain_change_keys(:to_s, :upcase)
      end.not_to(change { hash })
    end
  end

  describe '#ichain_change_keys!' do
    it_behaves_like 'a method that is able to chain change keys',
                    :chain_change_keys!

    it 'affects the original hash' do
      expect do
        hash.chain_change_keys!(:to_s, :upcase)
      end.to(change { hash })
    end
  end
end

shared_examples 'a method that is able to chain change keys' do |method|
  let(:result)          { hash.public_send(method, *transformations, options) }
  let(:options)         { {} }
  let(:transformations) { [:to_s] }

  context 'with simple level hash' do
    let(:hash) { { 'a' => 1, b: 2 } }

    context 'with symbol transformation' do
      let(:transformations) { [:to_sym] }
      let(:expected)        { { a: 1, b: 2 } }

      it_behaves_like 'result is as expected'
    end

    context 'with string transformation' do
      let(:expected) { { 'a' => 1, 'b' => 2 } }

      it_behaves_like 'result is as expected'
    end
  end

  context 'with recursive hash' do
    let(:hash) { { 'a' => 1, b: { c: 3, 'd' => 4 } } }
    let(:expected) do
      { 'a' => 1, 'b' => { 'c' => 3, 'd' => 4 } }
    end

    context 'when no options are given' do
      it_behaves_like 'result is as expected'
    end

    context 'when options are given' do
      let(:options) { { recursive: recursive } }

      context 'with recursion' do
        let(:recursive) { true }

        it_behaves_like 'result is as expected'
      end

      context 'without recursion' do
        let(:recursive) { false }
        let(:expected) { { 'a' => 1, 'b' => { c: 3, 'd' => 4 } } }

        it_behaves_like 'result is as expected'
      end
    end
  end

  context 'with many many levels' do
    let(:hash) { { a: 1, b: { c: 2, d: { e: 3, f: 4 } } } }
    let(:expected) do
      { 'a' => 1, 'b' => { 'c' => 2, 'd' => { 'e' => 3, 'f' => 4 } } }
    end

    it_behaves_like 'result is as expected'
  end

  context 'when calling with chained transformations' do
    let(:transformations) { %i[to_s upcase to_sym] }

    let(:expected) do
      { A: 1, B: 2, C: { D: 3, E: 4 }, F: [{ G: 5 }, { H: 6 }] }
    end

    it_behaves_like 'result is as expected'
  end
end
