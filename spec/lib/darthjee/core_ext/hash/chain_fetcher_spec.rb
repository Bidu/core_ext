# frozen_string_literal: true

require 'spec_helper'

describe Darthjee::CoreExt::Hash::ChainFetcher do
  subject { described_class.new(hash, *keys, &block) }

  it_behaves_like 'an object with capable of performing chain fetch' do
    let(:result) { subject.fetch }
  end
end
