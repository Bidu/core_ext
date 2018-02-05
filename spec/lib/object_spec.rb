require 'spec_helper'

describe Object do
  describe '#is_any?' do
    subject { 1 }

    it do
      expect(subject).to respond_to(:is_any?)
    end

    context 'when no argument is passed' do
      it do
        expect(subject.is_any?).to be_falsey
      end
    end

    context 'when passing the correct class as argument' do
      it do
        expect(subject.is_any?(subject.class)).to be_truthy
      end

      context 'along any other class' do
        it do
          expect(subject.is_any?(Symbol, subject.class)).to be_truthy
        end
      end
    end

    context 'when passing the wrong class' do
      it do
        expect(subject.is_any?(Symbol)).to be_falsey
      end
    end
  end
end
