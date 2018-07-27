# frozen_string_literal: true

shared_examples 'a class with change_values method' do
  let(:subject) { { a: 1, b: 2, c: { d: 3, e: 4 } } }
  let(:inner_hash) { subject[:c] }

  describe :change_values do
    it_behaves_like 'a method that change the hash values', :change_values

    it 'does not change original hash' do
      expect do
        subject.change_values { |value| value + 1 }
      end.not_to(change { subject })
    end

    it 'does not change original hash' do
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

    it 'changes original hash' do
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
      expect(subject.public_send(method, skip_inner: true) { |value| value.is_a?(Hash) ?  10 + value.size : value + 1 }).to eq(a: 2, b: 3, c: { d: 4, e: 5 })
    end

    it 'ignore hash and does not work recursively when option is passed' do
      expect(subject.public_send(method, skip_inner: false, recursive: false) { |value| value.is_a?(Hash) ? value : value + 1 }).to eq(a: 2, b: 3, c: { d: 3, e: 4 })
    end
  end

  context 'when using deeply nested arrays' do
    let(:subject) { { a: 1, b: 2, c: [{ d: 3 }, { e: { f: 4 } }, 5] } }

    it 'goes recursivly true arrays' do
      expect(subject.public_send(method) { |value| value + 1 }).to eq(a: 2, b: 3, c: [{ d: 4 }, { e: { f: 5 } }, 6])
    end

    it 'does not work recursively when parameter is passed as false' do
      expect(subject.public_send(method, recursive: false) { |value| value + 1 }).to eq(a: 2, b: 3, c: [{ d: 3 }, { e: { f: 4 } }, 5])
    end

    it 'does not ignore array when option is passed' do
      expect(subject.public_send(method, skip_inner: false) { |value| value.is_a?(Array) ? 10 + value.size : value + 1 }).to eq(a: 2, b: 3, c: 13)
    end

    it 'ignores array when option is passed' do
      expect(subject.public_send(method, skip_inner: true) { |value| value.is_a?(Array) ? 10 + value.size : value + 1 }).to eq(a: 2, b: 3, c: [{ d: 4 }, { e: { f: 5 } }, 6])
    end

    it 'ignore hash and does not work recursively when option is passed' do
      expect(subject.public_send(method, skip_inner: false, recursive: false) { |value| value.is_a?(Array) ? value : value + 1 }).to eq(a: 2, b: 3, c: [{ d: 3 }, { e: { f: 4 } }, 5])
    end
  end

  context 'when using a nested extra class' do
    let(:subject) { { a: 1, b: 2, c: Hash::ValueChanger::Dummy.new(3) } }

    it 'goes perform the mapping with the extra class' do
      expect(subject.public_send(method) { |value| value + 1 }).to eq(a: 2, b: 3, c: 4)
    end

    context 'when class is an interactor' do
      let(:subject) { { a: 1, b: 2, c: Hash::ValueChanger::DummyIteractor.new({ d: 3 }, e: { f: 4 }) } }

      it 'goes through the iteractor' do
        expect(subject.public_send(method) { |value| value + 1 }).to eq(a: 2, b: 3, c: [{ d: 4 }, { e: { f: 5 } }])
      end
    end

    context 'when using mapping inner array with inner object into a new hash' do
      let(:object) { Hash::ValueChanger::Dummy.new(2) }
      let(:array) { Hash::ValueChanger::DummyIteractor.new(object) }
      let(:subject) { { a: 1, b: array } }
      let(:result) do
        subject.public_send(method, skip_inner: false) do |value|
          if value.is_a?(Numeric)
            value + 10
          elsif value.is_a?(Hash) || value.is_a?(Hash::ValueChanger::DummyIteractor)
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
