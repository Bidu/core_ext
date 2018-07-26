# frozen_string_literal: true

shared_examples 'a class with transpose method' do |method|
  let(:hash) { { a: 1 } }

  describe "##{method}" do
    it 'swap keys with values' do
      expect(hash.public_send(method)).to eq(1 => :a)
    end

    it 'works when repeating call' do
      expect(hash.public_send(method).public_send(method)).to eq(hash)
    end

    context 'when hash has sub hasehs' do
      let(:sub_hash) { { b: 1 } }
      let(:hash) { { a: sub_hash } }

      it 'do not work it recursively' do
        expect(hash.public_send(method)).to eq(sub_hash => :a)
      end

      it 'works when repeating call' do
        expect(hash.public_send(method).public_send(method)).to eq(hash)
      end

      context 'whe key is already a hash' do
        let(:key) { { c: 2 } }
        let(:hash) { { key => sub_hash } }

        it 'swap keys with values' do
          expect(hash.public_send(method)).to eq(sub_hash => key)
        end

        it 'works when repeating call' do
          expect(hash.public_send(method).public_send(method)).to eq(hash)
        end
      end
    end

    context 'when value is an array' do
      let(:hash) { { a: [1, 2] } }

      it 'swap keys with values' do
        expect(hash.public_send(method)).to eq([1, 2] => :a)
      end

      it 'works when repeating call' do
        expect(hash.public_send(method).public_send(method)).to eq(hash)
      end

      context 'when key is already an array' do
        let(:hash) { { [1, 2] => [3, 4] } }

        it 'swap keys with values' do
          expect(hash.public_send(method)).to eq([3, 4] => [1, 2])
        end

        it 'works when repeating call' do
          expect(hash.public_send(method).public_send(method)).to eq(hash)
        end
      end
    end

    context 'when there is a clash of keys' do
      let(:hash) { { a: :b, c: :b } }

      it 'uses the last key for value' do
        expect(hash.public_send(method)).to eq(b: :c)
      end
    end

    context 'when there is a key which alreay has been defined' do
      let(:hash) { { a: :b, b: :c } }

      it 'does not override values' do
        expect(hash.public_send(method)).to eq(b: :a, c: :b)
      end

      it 'works when repeating call' do
        expect(hash.public_send(method).public_send(method)).to eq(hash)
      end
    end
  end
end

shared_examples 'a class with transpose methods' do
  it_behaves_like 'a class with transpose method', :transpose do
    it do
      expect do
        hash.transpose
      end.not_to change { hash }
    end
  end
  it_behaves_like 'a class with transpose method', :transpose! do
    it do
      expect do
        hash.transpose!
      end.to change { hash }
    end
  end
end
