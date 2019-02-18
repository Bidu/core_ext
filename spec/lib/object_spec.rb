# frozen_string_literal: true

require 'spec_helper'

describe Object do
  describe '#is_any?' do
    subject { 1 }

    it do
      expect(subject).to respond_to(:is_any?)
    end

    context 'when no argument is passed' do
      it do
        expect(subject).not_to be_is_any
      end
    end

    context 'when passing the correct class as argument' do
      it do
        expect(subject).to be_is_any(subject.class)
      end

      context 'along any other class' do
        it do
          expect(subject).to be_is_any(Symbol, subject.class)
        end
      end
    end

    context 'when passing the wrong class' do
      it do
        expect(subject).not_to be_is_any(Symbol)
      end
    end
  end
end
