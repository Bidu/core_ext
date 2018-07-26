# frozen_string_literal: true

shared_examples 'result is as expected' do
  it 'is as expected' do
    expect(result).to eq(expected)
  end
end
