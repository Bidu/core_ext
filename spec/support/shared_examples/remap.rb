# frozen_string_literal: true

shared_examples 'a class with remap method' do
  let(:subject) { { a: 1, b: 2 } }

  describe :remap_keys do
    it_behaves_like 'a method that remaps the keys', :remap_keys

    it 'does not change the original hash' do
      expect { subject.remap_keys(a: :e) }.not_to(change { subject })
    end
  end

  describe :remap_keys! do
    it_behaves_like 'a method that remaps the keys', :remap_keys!

    it 'changes the original hash' do
      expect { subject.remap_keys!(a: :e) }.to(change { subject })
    end
  end
end

shared_examples 'a method that remaps the keys' do |method|
  let(:result) { subject.public_send(method, remap) }

  context 'when remap and hash keys match' do
    let(:remap) { { a: :e, b: :f } }

    it 'remaps the keys' do
      expect(result).to eq(e: 1, f: 2)
    end
  end

  context 'when remap and hash keys do not match' do
    let(:remap) { { b: :f } }

    it 'remap only the keys that match' do
      expect(result).to eq(a: 1, f: 2)
    end
  end

  context 'when there are keys out of the keys list' do
    let(:remap) { { c: :g } }

    it 'creates a nil valued key' do
      expect(result).to eq(a: 1, b: 2, g: nil)
    end
  end

  context 'when remap has no keys' do
    let(:remap) { {} }

    it 'does not remap the keys' do
      expect(result).to eq(a: 1, b: 2)
    end
  end

  context 'when remap has original array keys' do
    let(:remap) { { b: :a, a: :b } }

    it 'does not remap the keys' do
      expect(result).to eq(b: 1, a: 2)
    end
  end

  context 'when remap has original array keys' do
    let(:remap) { { a: :b, b: :c } }

    it 'does not remap the keys' do
      expect(result).to eq(b: 1, c: 2)
    end
  end

  context 'when changing the type of the key' do
    let(:remap) { { a: 'a' } }

    it 'does not remap the keys' do
      expect(result).to eq('a' => 1, b: 2)
    end

    context 'and the original key is an string' do
      let(:subject) { { 'a' => 1, 'b' => 2 } }
      let(:remap) { { 'a' => :a } }

      it 'does not remap the keys' do
        expect(result).to eq(a: 1, 'b' => 2)
      end
    end
  end
end
