# frozen_string_literal: true

require 'spec_helper'

describe Date do
  describe 'yard' do
    describe '#days_between' do
      subject { Date.new(2018, 11, 21) }

      context 'when checking against another date' do
        let(:other_date) { Date.new(2019, 11, 21) }

        it 'returns the days between' do
          expect(subject.days_between(other_date)).to eq(365)
        end
      end

      context 'when cheking agains a 4 years apart date' do
        let(:other_date) { Date.new(2014, 11, 21) }

        it 'returns the days between' do
          expect(subject.days_between(other_date)).to eq(1461)
        end
      end

      context 'when checking against time' do
        let(:time) { Time.new(2017, 11, 21, 12, 0, 0) }

        it 'ignores the hours' do
          expect(subject.days_between(time)).to eq(365)
        end
      end
    end
  end
end
