# frozen_string_literal: true

require 'spec_helper'

describe Darthjee::CoreExt::Hash::ToHashMapper do
  it_behaves_like 'a hash with map_to_hash method' do
    subject { described_class.new(hash) }
    let(:mapped) { subject.map(&mapping_block) }
  end
end
