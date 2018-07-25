describe Enumerable do
  describe '#clean!' do
    it_behaves_like 'an array clean method', :clean!
    it_behaves_like 'a hash clean method', :clean!

    it 'changes the original hash' do
      hash = { a: nil }
      expect { hash.clean! }.to change { hash }
    end

    it 'changes original array' do
      array = [{ a: nil }]
      expect { array.clean! }.to change { array }
    end
  end

  describe '#clean' do
    it_behaves_like 'an array clean method', :clean
    it_behaves_like 'a hash clean method', :clean

    it 'does not change the original hash' do
      hash = { a: nil }
      expect { hash.clean }.not_to change { hash }
    end

    it 'does not change the original array' do
      array = [{ a: nil }]
      expect { array.clean }.not_to change { array }
    end
  end
end
