describe Enumerable do
  describe '#clean!' do
    it_behaves_like 'an array clean method', :clean!
    it_behaves_like 'a hash clean method', :clean!
  end
end
