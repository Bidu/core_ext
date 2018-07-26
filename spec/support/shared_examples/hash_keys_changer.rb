# frozen_string_literal: true

shared_examples 'a class with change_key method' do
  let(:hash) do
    { 'a' => 1, b: 2, c: { d: 3, e: 4 }, f: [{ g: 5 }, { h: 6 }] }
  end

  describe :change_keys do
    it_behaves_like 'a method that is able to change keys', :change_keys
    it 'does not affects the original hash' do
      expect do
        hash.change_keys(recursive: true) { |k| "foo_#{k}" }
      end.not_to change { hash }
    end
  end

  describe :change_keys! do
    it_behaves_like 'a method that is able to change keys', :change_keys!

    it 'affects the original hash' do
      expect do
        hash.change_keys!(recursive: true) { |k| "foo_#{k}" }
      end.to change { hash }
    end
  end
end

shared_examples 'a method that is able to change keys' do |method|
  let(:foo_sym_transformation) do
    hash.public_send(method) { |k| "foo_#{k}".to_sym }
  end

  context 'with simple level hash' do
    let(:hash) { { 'a' => 1, b: 2 } }

    context 'with string transformation' do
      let(:result) do
        hash.public_send(method) { |k| "foo_#{k}" }
      end
      let(:expected) { { 'foo_a' => 1, 'foo_b' => 2 } }
      it_behaves_like 'result is as expected'
    end

    context 'with symbol transformation' do
      let(:result) { foo_sym_transformation }
      let(:expected) { { foo_a: 1, foo_b: 2 } }
      it_behaves_like 'result is as expected'
    end
  end

  context 'with recursive hash' do
    let(:hash) { { 'a' => 1, b: { c: 3, 'd' => 4 } } }
    let(:result) { hash.public_send(method, options) { |k| "foo_#{k}" } }
    let(:expected) do
      { 'foo_a' => 1, 'foo_b' => { 'foo_c' => 3, 'foo_d' => 4 } }
    end

    context 'when no options are given' do
      let(:options) { {} }
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
        let(:expected) { { 'foo_a' => 1, 'foo_b' => { c: 3, 'd' => 4 } } }
        it_behaves_like 'result is as expected'
      end
    end
  end

  context 'with many many levels' do
    let(:hash) { { a: 1, b: { c: 2, d: { e: 3, f: 4 } } } }
    let(:expected) do
      { foo_a: 1, foo_b: { foo_c: 2, foo_d: { foo_e: 3, foo_f: 4 } } }
    end
    let(:result) { foo_sym_transformation }
    it_behaves_like 'result is as expected'
  end
end
