# frozen_string_literal: true

require 'spec_helper'

describe Hash::KeysSorter do
  it_behaves_like 'a class with a keys sort method' do
    subject { described_class.new(hash, **options) }
    let(:result) { subject.sort }
  end
end
