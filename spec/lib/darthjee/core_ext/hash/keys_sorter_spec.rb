# frozen_string_literal: true

require 'spec_helper'

describe Darthjee::CoreExt::Hash::KeysSorter do
  subject { described_class.new(hash, **options) }

  let(:result) { subject.sort }

  it_behaves_like 'a class with a keys sort method'
  it_behaves_like 'a class with a keys sort method that changes original'
end
