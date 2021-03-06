shared_examples 'a class with change_kvalues method' do
  let(:subject) { { a: 1, b: 2, c: { d: 3, e: 4 } } }

  describe :change_values do
    it_behaves_like 'a method that change the hash values', :change_values

    it 'does not change original hash' do
      subject.change_values { |value| value + 1 }
      expect(subject).to eq(a: 1, b: 2, c: { d: 3, e: 4 })
    end

    it 'should call change_values!' do
      original = { 'a' => 1, c: { d: 3, e: 4 } }
      copy = { 'a' => 1, c: { d: 3, e: 4 } }

      expect(original).to receive(:deep_dup).and_return(copy)
      expect(copy).to receive(:change_values!)
      original.change_values { |value| value + 1 }
    end
  end

  describe :change_values! do
    it_behaves_like 'a method that change the hash values', :change_values!

    it 'changes original hash' do
      subject.change_values! { |value| value + 1 }

      expect(subject).to_not eq(a: 1, b: 2, c: { d: 3, e: 4 })
      expect(subject).to eq(a: 2, b: 3, c: { d: 4, e: 5 })
    end
  end
end

shared_examples 'a method that change the hash values' do |method|
  it 'updates values of hash' do
    expect(subject.public_send(method) { |value| value + 1 }).to eq(a: 2, b: 3, c: { d: 4, e: 5 })
  end

  it 'works recursively when parameter is passed' do
    expect(subject.change_values(recursive: true) { |value| value + 1 }).to eq(a: 2, b: 3, c: { d: 4, e: 5 })
  end

  it 'does not work recursively when parameter is passed as false' do
    expect(subject.change_values(recursive: false) { |value| value + 1 }).to eq(a: 2, b: 3, c: { d: 3, e: 4 })
  end

  it 'does not ignore hash when option is passed' do
    expect(subject.change_values(skip_inner: false) { |value| value.is_a?(Hash) ? 10 + value.size : value + 1 }).to eq(a: 2, b: 3, c: 12)
  end

  it 'ignore hash and work recursively when option is passed' do
    expect(subject.change_values(skip_inner: false) { |value| value.is_a?(Hash) ? value : value + 1 }).to eq(a: 2, b: 3, c: { d: 4, e: 5 })
  end

  it 'ignore hash and does not work recursively when option is passed' do
    expect(subject.change_values(skip_inner: false, recursive: false) { |value| value.is_a?(Hash) ? value : value + 1 }).to eq(a: 2, b: 3, c: { d: 3, e: 4 })
  end

  it 'applies to arrays as well' do
    subject = { a: 1, b: 2, c: [{ d: 3 }, { e: 4 }] }
    expect(subject.public_send(method) { |value| value + 1 }).to eq(a: 2, b: 3, c: [{ d: 4 }, { e: 5 }])
  end
end
