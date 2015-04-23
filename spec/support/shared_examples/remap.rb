shared_examples 'a class with remap method' do
  describe :remap_keys do
    let(:subject) { { a: 1, b: 2 } }
    let(:result) { subject.remap_keys(remap) }

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
  end
end