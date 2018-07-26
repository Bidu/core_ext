# frozen_string_literal: true

shared_examples 'a hash clean method' do |method|
  context 'when hash has one level' do
    let(:subject) do
      { a: 1, b: nil, c: '', d: {} }
    end

    let(:expected) do
      { a: 1 }
    end

    it 'cleans the hash from empty and nil values' do
      expect(subject.send(method)).to eq(expected)
    end
  end

  context 'when hash has two levels' do
    let(:subject) do
      { a: 1, c: '', d: { e: 1 }, f: { g: { b: nil } } }
    end

    let(:expected) do
      { a: 1, d: { e: 1 } }
    end

    it 'cleans the hash from empty and nil values' do
      expect(subject.send(method)).to eq(expected)
    end
  end

  context 'when hash has many levels' do
    let(:subject) do
      { a: 1, d: { e: { k: { l: { m: { n: 1 } } } } }, f: { g: { h: { i: { j: { c: '' } } } } } }
    end

    let(:expected) do
      { a: 1, d: { e: { k: { l: { m: { n: 1 } } } } } }
    end

    it 'cleans the hash from empty and nil values' do
      expect(subject.send(method)).to eq(expected)
    end
  end

  context 'when hash has one nil value and one valid value' do
    let(:subject) do
      { a: { b: 1, c: nil } }
    end

    let(:expected) do
      { a: { b: 1 } }
    end

    it 'cleans the hash from empty and nil values' do
      expect(subject.send(method)).to eq(expected)
    end
  end

  context 'when hash has arrays' do
    let(:subject) do
      { a: [] }
    end

    let(:expected) do
      {}
    end

    it 'cleans the hash from empty and nil values' do
      expect(subject.send(method)).to eq(expected)
    end
  end

  context 'when hash has arrays with hashes' do
    let(:subject) do
      { a: [{ c: nil }] }
    end

    let(:expected) do
      {}
    end

    it 'cleans the hash from empty and nil values' do
      expect(subject.send(method)).to eq(expected)
    end
  end

  context 'when hash has arrays with hashes with valid values' do
    let(:subject) do
      { a: [{ c: 1 }] }
    end

    let(:expected) do
      { a: [{ c: 1 }] }
    end

    it 'cleans the hash from empty and nil values' do
      expect(subject.send(method)).to eq(expected)
    end
  end

  context 'when hash has arrays with hashes with valid and invalid values' do
    let(:subject) do
      { a: [{ c: nil }, { d: 1 }] }
    end

    let(:expected) do
      { a: [{ d: 1 }] }
    end

    it 'cleans the hash from empty and nil values' do
      expect(subject.send(method)).to eq(expected)
    end
  end
end

shared_examples 'an array clean method' do |method|
  context 'when array has one level' do
    let(:subject) do
      [1, nil, '', {}, []]
    end

    let(:expected) do
      [1]
    end

    it 'cleans the hash from empty and nil values' do
      expect(subject.send(method)).to eq(expected)
    end
  end

  context 'when array has many levels' do
    let(:subject) do
      [1, nil, '', {}, [[[{ a: [[[[[[[]]]]]]] }]]], [[[[[[[2]]]]]]], [{ a: [2] }]]
    end

    let(:expected) do
      [1, [[[[[[[2]]]]]]], [{ a: [2] }]]
    end

    it 'cleans the hash from empty and nil values' do
      expect(subject.send(method)).to eq(expected)
    end
  end
end
