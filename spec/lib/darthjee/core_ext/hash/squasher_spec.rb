# frozen_string_literal: true

require 'spec_helper'

describe Darthjee::CoreExt::Hash::Squasher do
  describe '#squash' do
    it_behaves_like 'a method to squash a hash' do
      let(:squashed) { described_class.new.squash(hash) }
    end

    it_behaves_like 'a method to squash a hash', '/' do
      let(:squashed) { described_class.new('/').squash(hash) }
    end
  end
end
