require 'spec_helper'

describe Symbol do
  describe '#camelize' do
    it { expect(:sym.camelize).to be_kind_of(Symbol) }

    context 'when called with upper option' do
      it 'camelize the symbol' do
        expect(:underscore_sym.camelize(:upper)).to eq(:UnderscoreSym)
      end
    end

    context 'when called with lower option' do
      it 'snake case the symbol' do
        expect(:underscore_sym.camelize(:lower)).to eq(:underscoreSym)
      end
    end

    context 'when called without option' do
      it 'camelize the symbol' do
        expect(:underscore_sym.camelize).to eq(:UnderscoreSym)
      end
    end
  end
end
