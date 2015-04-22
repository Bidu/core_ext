shared_examples 'a class with change_key method' do
  describe :change_keys do
    it_behaves_like 'a mnethod that is able to change keys', :change_keys

    it 'should call change_keys!' do
      original = { 'a' => 1, b: 2, c: { d: 3, e: 4 } }
      copy = { 'a' => 1, b: 2, c: { d: 3, e: 4 } }
      expected = { 'foo_a' => 1, 'foo_b' => 2, 'foo_c' =>  { 'foo_d' => 3, 'foo_e' => 4 } }

      expect(original).to receive(:deep_dup).and_return(copy)
      expect(copy).to receive(:change_keys!)
      original.change_keys(recursive: true) { |k| "foo_#{k}" }
    end

    it 'does not affects the original hash' do
      original = { 'a' => 1, b: 2, c: { d: 3, e: 4 }, f: [{ g: 5 }, { h: 6 }] }
      expected = { 'a' => 1, b: 2, c: { d: 3, e: 4 }, f: [{ g: 5 }, { h: 6 }] }
      original.change_keys(recursive: true) { |k| "foo_#{k}" }
      expect(original).to eq(expected)
    end
  end

  describe :change_keys! do
    it_behaves_like 'a mnethod that is able to change keys', :change_keys!

    it 'affects the original hash' do
      original = { 'a' => 1, b: 2, c: { d: 3, e: 4 }, f: [{ g: 5 }, { h: 6 }] }
      not_expected = { 'a' => 1, b: 2, c: { d: 3, e: 4 }, f: [{ g: 5 }, { h: 6 }] }
      original.change_keys!(recursive: true) { |k| "foo_#{k}" }
      expect(original).to_not eq(not_expected)
    end
  end
end

shared_examples 'a mnethod that is able to change keys' do |method|
  it 'accepts block to change the keys' do
    { 'a' => 1, b: 2 }.public_send(method) { |k| "foo_#{k}" }.should eq('foo_a' => 1, 'foo_b' => 2)
  end

  it 'accepts block to change the keys' do
    { a: 1, 'b' => 2 }.public_send(method) { |k| "foo_#{k}".to_sym }.should eq(foo_a: 1, foo_b: 2)
  end

  it 'applies the block recursively' do
    { 'a' => 1, b:  { c: 3, d: 4 } }.public_send(method) { |k| "foo_#{k}" }.should eq('foo_a' => 1, 'foo_b' =>  { 'foo_c' => 3, 'foo_d' => 4 })
  end

  it 'applies the block recursively when passed in options' do
    { 'a' => 1, b:  { c: 3, d: 4 } }.public_send(method, recursive: true) { |k| "foo_#{k}" }.should eq('foo_a' => 1, 'foo_b' =>  { 'foo_c' => 3, 'foo_d' => 4 })
  end

  it 'does not apply the block recursively when passed in options' do
    { 'a' => 1, b:  { c: 3, 'd' => 4 } }.public_send(method, recursive: false) { |k| "foo_#{k}" }.should eq('foo_a' => 1, 'foo_b' =>  { c: 3, 'd' => 4 })
  end

  it 'apply recursion on many levels' do
    hash = { a: 1, b: { c: 2, d: { e: 3, f: 4 } } }
    expected = { foo_a: 1, foo_b: { foo_c: 2, foo_d: { foo_e: 3, foo_f: 4 } } }
    hash.public_send(method, recursive: true) { |k| "foo_#{k}".to_sym }.should eq(expected)
  end

  it 'respect options on recursion' do
    hash = { a: 1, b: { c: 2, d: { e: 3, f: 4 } } }
    expected = { foo_a: 1, foo_b: { c: 2, d: { e: 3, f: 4 } } }
    hash.public_send(method, recursive: false) { |k| "foo_#{k}".to_sym }.should eq(expected)
  end
end
