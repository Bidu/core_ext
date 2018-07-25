shared_examples 'a class with append_keys method' do
  describe :prepend_to_keys do
    it 'accepts block to change the keys' do
      expect({ a: 1, 'b' => 2 }.prepend_to_keys('foo_')).to eq(foo_a: 1, 'foo_b' => 2)
    end
    it 'applies the block recursively' do
      expect({ 'a' => 1, b: { c: 3, 'd' => 4 } }.prepend_to_keys('foo_')).to eq('foo_a' => 1, foo_b: { foo_c: 3, 'foo_d' => 4 })
    end
    it 'changes type when type option is passed' do
      expect({ 'a' => 1, b: 2 }.prepend_to_keys('foo_', type: :string)).to eq('foo_a' => 1, 'foo_b' => 2)
    end
    it 'changes type when type option is passed' do
      expect({ 'a' => 1, b: 2 }.prepend_to_keys('foo_', type: :symbol)).to eq(foo_a: 1, foo_b: 2)
    end
    it 'keep type when type option is passed as keep' do
      expect({ 'a' => 1, b: 2 }.prepend_to_keys('foo_', type: :keep)).to eq('foo_a' => 1, foo_b: 2)
    end
    it 'applies to array as well' do
      expect({ 'a' => 1, b: [{ c: 2 }, { d: 3 }] }.prepend_to_keys('foo_', type: :keep)).to eq('foo_a' => 1, foo_b: [{ foo_c: 2 }, { foo_d: 3 }])
    end
  end

  describe :append_to_keys do
    it 'accepts block to change the keys' do
      expect({ a: 1, 'b' => 2 }.append_to_keys('_bar')).to eq(a_bar: 1, 'b_bar' => 2)
    end
    it 'applies the block recursively' do
      expect({ 'a' => 1, b: { c: 3, 'd' => 4 } }.append_to_keys('_bar')).to eq('a_bar' => 1, b_bar: { c_bar: 3, 'd_bar' => 4 })
    end
    it 'changes type when type option is passed' do
      expect({ 'a' => 1, b: 2 }.append_to_keys('_bar', type: :string)).to eq('a_bar' => 1, 'b_bar' => 2)
    end
    it 'changes type when type option is passed' do
      expect({ 'a' => 1, b: 2 }.append_to_keys('_bar', type: :symbol)).to eq(a_bar: 1, b_bar: 2)
    end
    it 'keep type when type option is passed as keep' do
      expect({ 'a' => 1, b: 2 }.append_to_keys('_bar', type: :keep)).to eq('a_bar' => 1, b_bar: 2)
    end
    it 'applies to array as well' do
      expect({ 'a' => 1, b: [{ c: 2 }, { d: 3 }] }.append_to_keys('_bar', type: :keep)).to eq('a_bar' => 1, b_bar: [{ c_bar: 2 }, { d_bar: 3 }])
    end
  end
end
