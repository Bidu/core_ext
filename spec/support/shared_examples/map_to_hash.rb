# frozen_string_literal: true

shared_examples 'an array with map_to_hash method' do
  describe '#map_to_hash' do
    let(:subject) { %w[word1 wooord2] }
    let(:mapping_block) { proc { |word| word.length } }
    let(:mapped) { subject.map_to_hash(&mapping_block) }
    let(:expected) { { 'word1' => 5, 'wooord2' => 7 } }

    it { expect(mapped).to be_a(Hash) }

    it 'has the original array as keys' do
      expect(mapped.keys).to eq(subject)
    end

    it 'has the mapped values as values' do
      expect(mapped.values).to eq(subject.map(&mapping_block))
    end

    it 'correctly map keys to value' do
      expect(mapped).to eq(expected)
    end

    context 'whe subject is an array' do
      let(:subject) { [%w[w1], %w[w2 w3]] }
      let(:mapped) { subject.map_to_hash(&mapping_block) }
      let(:expected) { { %w[w1] => 1, %w[w2 w3] => 2 } }

      it 'has the original array as keys' do
        expect(mapped.keys).to eq(subject)
      end

      it 'has the mapped values as values' do
        expect(mapped.values).to eq(subject.map(&mapping_block))
      end

      it 'correctly map keys to value' do
        expect(mapped).to eq(expected)
      end
    end
  end
end

shared_examples 'a hash with map_to_hash method' do
  describe '#map_to_hash' do
    let(:hash) { { a: 1, b: 2 } }
    let(:mapping_block) { proc { |k, v| "#{k}_#{v}" } }
    let(:expected) { { a: 'a_1', b: 'b_2' } }

    it { expect(mapped).to be_a(Hash) }

    it do
      expect { mapped }.not_to(change { hash })
    end

    it 'has the original keys as keys' do
      expect(mapped.keys).to eq(hash.keys)
    end

    it 'has the mapped values as values' do
      expect(mapped.values).to eq(hash.map(&mapping_block))
    end

    it 'correctly map keys to value' do
      expect(mapped).to eq(expected)
    end

    context 'when hash uses arrays for keys' do
      let(:hash) { { %i[a b] => 1, %i[c d] => 2 } }
      let(:mapping_block) { proc { |k, v| "#{k.join('_')}_#{v}" } }
      let(:expected) { { %i[a b] => 'a_b_1', %i[c d] => 'c_d_2' } }

      it 'has the original keys as keys' do
        expect(mapped.keys).to eq(hash.keys)
      end

      it 'has the mapped values as values' do
        expect(mapped.values).to eq(hash.map(&mapping_block))
      end

      it 'correctly map keys to value' do
        expect(mapped).to eq(expected)
      end
    end
  end
end
