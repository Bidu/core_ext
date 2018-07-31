# frozen_string_literal: true

require 'spec_helper'

describe Hash::KeysRemapper do
  subject { described_class.new(hash) }

  describe '#remap_keys!' do
    it_behaves_like 'a method that remaps the keys', :remap do
      it 'changes the original hash' do
        expect { result }.to(change { hash })
      end
    end
  end
end
