# frozen_string_literal: true

require 'spec_helper'

describe Enumerable do
  describe '#clean!' do
    context 'when subject is a hash' do
      subject(:hash) do
        {
          keep: 'value',
          nil_value: nil,
          empty_array: [],
          empty_string: '',
          empty_hash: {}
        }
      end

      it 'removes empty values' do
        expect { hash.clean! }.to change { hash }.to(keep: 'value')
      end
    end

    context 'when subject is an array' do
      subject(:array) do
        ['value', nil, [], '', {}]
      end

      it 'removes empty values' do
        expect { array.clean! }.to change { array }.to(['value'])
      end
    end
  end
end
