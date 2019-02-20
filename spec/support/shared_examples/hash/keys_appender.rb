# frozen_string_literal: true

shared_examples 'a class with append_keys method' do
  describe '#prepend_to_keys' do
    it 'accepts block to change the keys' do
      hash = { a: 1, 'b' => 2 }
      expected = { foo_a: 1, 'foo_b' => 2 }
      expect(hash.prepend_to_keys('foo_')).to eq(expected)
    end

    it 'applies the block recursively' do
      hash = { 'a' => 1, b: { c: 3, 'd' => 4 } }
      expected = { 'foo_a' => 1, foo_b: { foo_c: 3, 'foo_d' => 4 } }
      expect(hash.prepend_to_keys('foo_')).to eq(expected)
    end

    it 'changes type to string when type string option is passed' do
      hash = { 'a' => 1, b: 2 }
      expected = { 'foo_a' => 1, 'foo_b' => 2 }
      expect(hash.prepend_to_keys('foo_', type: :string)).to eq(expected)
    end

    it 'changes type to symbol when type symbol option is passed' do
      hash = { 'a' => 1, b: 2 }
      expected = { foo_a: 1, foo_b: 2 }
      expect(hash.prepend_to_keys('foo_', type: :symbol)).to eq(expected)
    end

    it 'keep type when type option is passed as keep' do
      hash = { 'a' => 1, b: 2 }
      expected = { 'foo_a' => 1, foo_b: 2 }
      expect(hash.prepend_to_keys('foo_', type: :keep)).to eq(expected)
    end

    it 'applies to array as well' do
      hash = { 'a' => 1, b: [{ c: 2 }, { d: 3 }] }
      expected = { 'foo_a' => 1, foo_b: [{ foo_c: 2 }, { foo_d: 3 }] }
      expect(hash.prepend_to_keys('foo_', type: :keep)).to eq(expected)
    end
  end

  describe '#append_to_keys' do
    it 'accepts block to change the keys' do
      hash = { a: 1, 'b' => 2 }
      expected = { a_bar: 1, 'b_bar' => 2 }
      expect(hash.append_to_keys('_bar')).to eq(expected)
    end

    it 'applies the block recursively' do
      hash = { 'a' => 1, b: { c: 3, 'd' => 4 } }
      expected = { 'a_bar' => 1, b_bar: { c_bar: 3, 'd_bar' => 4 } }
      expect(hash.append_to_keys('_bar')).to eq(expected)
    end

    it 'changes type to string when type string option is passed' do
      hash = { 'a' => 1, b: 2 }
      expected = { 'a_bar' => 1, 'b_bar' => 2 }
      expect(hash.append_to_keys('_bar', type: :string)).to eq(expected)
    end

    it 'changes type to symbol when type symbol option is passed' do
      hash = { 'a' => 1, b: 2 }
      expected = { a_bar: 1, b_bar: 2 }
      expect(hash.append_to_keys('_bar', type: :symbol)).to eq(expected)
    end

    it 'keep type when type option is passed as keep' do
      hash = { 'a' => 1, b: 2 }
      expected = { 'a_bar' => 1, b_bar: 2 }
      expect(hash.append_to_keys('_bar', type: :keep)).to eq(expected)
    end

    it 'applies to array as well' do
      hash = { 'a' => 1, b: [{ c: 2 }, { d: 3 }] }
      expected = { 'a_bar' => 1, b_bar: [{ c_bar: 2 }, { d_bar: 3 }] }
      expect(hash.append_to_keys('_bar', type: :keep)).to eq(expected)
    end
  end
end
