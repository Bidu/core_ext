shared_examples 'a class with change_values method' do
  let(:subject) { { a: 1, b: 2, c: { d: 3, e: 4 } } }

  describe :change_values do
    it_behaves_like 'a method that change the hash values', :change_values

    it 'does not change original hash' do
      expect do
        subject.change_values { |value| value + 1 }
      end.not_to change { subject }
    end
  end

  describe :change_values! do
    it_behaves_like 'a method that change the hash values', :change_values!

    it 'changes original hash' do
      expect do
        subject.change_values! { |value| value + 1 }
      end.to change { subject }
    end
  end
end

shared_examples 'a method that change the hash values' do |method|
  context 'when using deeply nested hashes' do
    it 'updates values of hash' do
      expect(subject.public_send(method) { |value| value + 1 }).to eq(a: 2, b: 3, c: { d: 4, e: 5 })
    end
  
    it 'works recursively when parameter is passed' do
      expect(subject.public_send(method, recursive: true) { |value| value + 1 }).to eq(a: 2, b: 3, c: { d: 4, e: 5 })
    end
  
    it 'does not work recursively when parameter is passed as false' do
      expect(subject.public_send(method, recursive: false) { |value| value + 1 }).to eq(a: 2, b: 3, c: { d: 3, e: 4 })
    end
  
    it 'does not ignore hash when option is passed' do
      expect(subject.public_send(method, skip_inner: false) { |value| value.is_a?(Hash) ? 10 + value.size : value + 1 }).to eq(a: 2, b: 3, c: 12)
    end
  
    it 'ignore hash and work recursively when option is passed' do
      expect(subject.public_send(method, skip_inner: false) { |value| value.is_a?(Hash) ? value : value + 1 }).to eq(a: 2, b: 3, c: { d: 4, e: 5 })
    end
  
    it 'ignore hash and does not work recursively when option is passed' do
      expect(subject.public_send(method, skip_inner: false, recursive: false) { |value| value.is_a?(Hash) ? value : value + 1 }).to eq(a: 2, b: 3, c: { d: 3, e: 4 })
    end
  end
  
  context 'when using deeply nested hashes' do
    let(:subject) { { a: 1, b: 2, c: [{ d: 3 }, { e: { f: 4 } } ] } }

    it 'goes recursivly true arrays' do
      expect(subject.public_send(method) { |value| value + 1 }).to eq(a: 2, b: 3, c: [{ d: 4 }, { e: { f: 5 } }])
    end

    it 'does not work recursively when parameter is passed as false' do
      expect(subject.public_send(method, recursive: false) { |value| value + 1 }).to eq(a: 2, b: 3, c: [{ d: 3 }, { e: { f: 4 } }])
    end
  end
end
