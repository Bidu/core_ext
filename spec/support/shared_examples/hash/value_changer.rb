# frozen_string_literal: true

shared_examples 'a class with change_values method' do
  let(:subject)    { { a: 1, b: 2, c: { d: 3, e: 4 } } }
  let(:inner_hash) { subject[:c] }

  describe :change_values do
    it_behaves_like 'a method that change the hash values', :change_values

    it 'does not change original hash' do
      expect do
        subject.change_values { |value| value + 1 }
      end.not_to(change { subject })
    end

    it 'does not change original inner hash' do
      expect do
        subject.change_values { |value| value + 1 }
      end.not_to(change { inner_hash })
    end

    context 'when using an array' do
      let(:subject) { { a: [{ b: 1 }] } }
      let(:inner_array) { subject[:a] }

      it 'does not change original hash' do
        expect do
          subject.change_values { |value| value + 1 }
        end.not_to(change { inner_array })
      end
    end
  end

  describe :change_values! do
    it_behaves_like 'a method that change the hash values', :change_values!

    it 'changes original hash' do
      expect do
        subject.change_values! { |value| value + 1 }
      end.to(change { subject })
    end

    it 'changes original inner hash' do
      expect do
        subject.change_values! { |value| value + 1 }
      end.to(change { inner_hash })
    end

    context 'when using an array' do
      let(:subject) { { a: [{ b: 1 }] } }
      let(:inner_array) { subject[:a] }

      it 'changes original hash' do
        expect do
          subject.change_values! { |value| value + 1 }
        end.to(change { inner_array })
      end
    end
  end
end

shared_examples 'a method that change the hash values' do |method|
  context 'when using deeply nested hashes' do
    it 'updates values of hash' do
      result = subject.public_send(method) { |value| value + 1 }
      expected = { a: 2, b: 3, c: { d: 4, e: 5 } }
      expect(result).to eq(expected)
    end

    it 'works recursively when parameter is passed' do
      result = subject.public_send(method, recursive: true) do |value|
        value + 1
      end
      expected = { a: 2, b: 3, c: { d: 4, e: 5 } }
      expect(result).to eq(expected)
    end

    it 'does not work recursively when parameter is passed as false' do
      result = subject.public_send(method, recursive: false) do |value|
        value + 1
      end
      expected = { a: 2, b: 3, c: { d: 3, e: 4 } }
      expect(result).to eq(expected)
    end

    it 'does not ignore hash when option is passed' do
      result = subject.public_send(method, skip_inner: false) do |value|
        value.is_a?(Hash) ? 10 + value.size : value + 1
      end
      expected = { a: 2, b: 3, c: 12 }
      expect(result).to eq(expected)
    end

    it 'ignore hash and work recursively when option is passed' do
      result = subject.public_send(method, skip_inner: true) do |value|
        value.is_a?(Hash) ? 10 + value.size : value + 1
      end
      expect(result).to eq(a: 2, b: 3, c: { d: 4, e: 5 })
    end

    it 'ignore hash and does not work recursively when option is passed' do
      options = { skip_inner: false, recursive: false }
      result = subject.public_send(method, options) do |value|
        value.is_a?(Hash) ? value : value + 1
      end
      expect(result).to eq(a: 2, b: 3, c: { d: 3, e: 4 })
    end
  end

  context 'when using deeply nested arrays' do
    let(:subject) { { a: 1, b: 2, c: [{ d: 3 }, { e: { f: 4 } }, 5] } }

    it 'goes recursivly true arrays' do
      result = subject.public_send(method) { |value| value + 1 }

      expect(result).to eq(a: 2, b: 3, c: [{ d: 4 }, { e: { f: 5 } }, 6])
    end

    it 'does not work recursively when parameter is passed as false' do
      result = subject.public_send(method, recursive: false) do |value|
        value + 1
      end
      expect(result).to eq(a: 2, b: 3, c: [{ d: 3 }, { e: { f: 4 } }, 5])
    end

    it 'does not ignore array when option is passed' do
      result = subject.public_send(method, skip_inner: false) do |value|
        value.is_a?(Array) ? 10 + value.size : value + 1
      end
      expect(result).to eq(a: 2, b: 3, c: 13)
    end

    it 'ignores array when option is passed' do
      result = subject.public_send(method, skip_inner: true) do |value|
        value.is_a?(Array) ? 10 + value.size : value + 1
      end
      expect(result).to eq(a: 2, b: 3, c: [{ d: 4 }, { e: { f: 5 } }, 6])
    end

    it 'ignore hash and does not work recursively when option is passed' do
      options = { skip_inner: false, recursive: false }
      result = subject.public_send(method, options) do |value|
        value.is_a?(Array) ? value : value + 1
      end
      expect(result).to eq(a: 2, b: 3, c: [{ d: 3 }, { e: { f: 4 } }, 5])
    end
  end

  context 'when using a nested extra class' do
    let(:subject)  { { a: 1, b: 2, c: Hash::ValueChanger::Dummy.new(3) } }
    let(:result)   { subject.public_send(method) { |value| value + 1 } }
    let(:expected) { { a: 2, b: 3, c: 4 } }

    it 'goes perform the mapping with the extra class' do
      expect(result).to eq(expected)
    end

    context 'when class is an interactor' do
      subject { { a: 1, b: 2, c: object } }

      let(:expected) { { a: 2, b: 3, c: [{ d: 4 }, { e: { f: 5 } }] } }
      let(:object) do
        Hash::ValueChanger::DummyIteractor.new({ d: 3 }, e: { f: 4 })
      end

      it 'goes through the iteractor' do
        expect(result).to eq(expected)
      end
    end

    context 'when using mapping inner array with inner objecth' do
      let(:object)  { Hash::ValueChanger::Dummy.new(2) }
      let(:array)   { Hash::ValueChanger::DummyIteractor.new(object) }
      let(:subject) { { a: 1, b: array } }
      let(:result) do
        subject.public_send(method, skip_inner: false) do |value|
          case value
          when Numeric
            value + 10
          when Hash, Hash::ValueChanger::DummyIteractor
            value
          else
            value.as_json
          end
        end
      end

      it 'process the object after processing the array' do
        expect(result).to eq(a: 11, b: [{ val: 12 }])
      end
    end
  end
end
