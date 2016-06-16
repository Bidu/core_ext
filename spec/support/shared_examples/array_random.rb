shared_examples 'a method that returns a random element' do
  let(:array) { [ 7, 5, 3 ] }

  (0..2).each do |index|
    context "when random returns #{index}" do
      let!(:expected) { array[index] }
      before do
        allow_any_instance_of(Array).to receive(:rand).with(array.size) { index }
      end

      it 'returns the randomized index of the array' do
        expect(array.random).to eq(expected)
      end
    end
  end
end
