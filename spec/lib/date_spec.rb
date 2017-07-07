require 'spec_helper'

describe Date do
  let(:year) { 2018 }
  let(:month) { 10 }
  let(:day) { 4 }
  let(:subject) { Date.new(year, month, day) }

  describe '#days_between' do
    let(:other_date) { subject + difference }
    let(:difference) { 1.year }

    context 'when other date is one year ahead' do
      it { expect(subject.days_between(other_date)).to eq(365) }
    end

    context 'when other date is one year behind' do
      let(:difference) { - 1.year }

      it { expect(subject.days_between(other_date)).to eq(365) }
    end

    context 'when initial date is on a leap year' do
      let(:year) { 2016 }

      context 'when other date is one year ahead' do
        it { expect(subject.days_between(other_date)).to eq(365) }
      end

      context 'when other date is one year behind' do
        let(:difference) { - 1.year }

        it { expect(subject.days_between(other_date)).to eq(366) }
      end
    end

    context 'when initial date is before a leap year' do
      let(:year) { 2015 }

      context 'when other date is one year ahead' do
        it { expect(subject.days_between(other_date)).to eq(366) }
      end

      context 'when other date is one year behind' do
        let(:difference) { - 1.year }

        it { expect(subject.days_between(other_date)).to eq(365) }
      end
    end
  end
end