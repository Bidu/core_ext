shared_examples 'a class with append_keys method' do
  describe :prepend_to_keys do
    it 'accepts block to change the keys' do
      { a: 1, 'b' => 2 }.prepend_to_keys('foo_').should eq(foo_a: 1, 'foo_b' => 2)
    end
    it 'applies the block recursively' do
      { 'a' => 1, b:  { c: 3, 'd' => 4 } }.prepend_to_keys('foo_').should eq('foo_a' => 1, foo_b:  { foo_c: 3, 'foo_d' => 4 })
    end
    it 'changes type when type option is passed' do
      { 'a' => 1, b: 2 }.prepend_to_keys('foo_', type: :string).should eq('foo_a' => 1, 'foo_b' => 2)
    end
    it 'changes type when type option is passed' do
      { 'a' => 1, b: 2 }.prepend_to_keys('foo_', type: :symbol).should eq(foo_a: 1, foo_b: 2)
    end
    it 'keep type when type option is passed as keep' do
      { 'a' => 1, b: 2 }.prepend_to_keys('foo_', type: :keep).should eq('foo_a' => 1, foo_b: 2)
    end
    it 'applies to array as well' do
      { 'a' => 1, b: [{ c: 2 }, { d: 3 }] }.prepend_to_keys('foo_', type: :keep).should eq('foo_a' => 1, foo_b: [{ foo_c: 2 }, { foo_d: 3 }])
    end
  end

  describe :append_to_keys do
    it 'accepts block to change the keys' do
      { a: 1, 'b' => 2 }.append_to_keys('_bar').should eq(a_bar: 1, 'b_bar' => 2)
    end
    it 'applies the block recursively' do
      { 'a' => 1, b:  { c: 3, 'd' => 4 } }.append_to_keys('_bar').should eq('a_bar' => 1, b_bar:  { c_bar: 3, 'd_bar' => 4 })
    end
    it 'changes type when type option is passed' do
      { 'a' => 1, b: 2 }.append_to_keys('_bar', type: :string).should eq('a_bar' => 1, 'b_bar' => 2)
    end
    it 'changes type when type option is passed' do
      { 'a' => 1, b: 2 }.append_to_keys('_bar', type: :symbol).should eq(a_bar: 1, b_bar: 2)
    end
    it 'keep type when type option is passed as keep' do
      { 'a' => 1, b: 2 }.append_to_keys('_bar', type: :keep).should eq('a_bar' => 1, b_bar: 2)
    end
    it 'applies to array as well' do
      { 'a' => 1, b: [{ c: 2 }, { d: 3 }] }.append_to_keys('_bar', type: :keep).should eq('a_bar' => 1, b_bar: [{ c_bar: 2 }, { d_bar: 3 }])
    end
  end
end
