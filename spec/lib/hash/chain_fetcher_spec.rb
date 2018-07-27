# frozen_string_literal: true

require 'spec_helper'

describe Hash::ChainFetcher do
  subject { described_class.new(hash, *keys) }

  it_behaves_like 'an object with capable of performing chain fetch' do
    let(:result) { subject.fetch(&block) }
  end
end
