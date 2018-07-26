# frozen_string_literal: true

shared_examples 'an object that knows how to calculate days between' do
  let(:other_date) { subject.to_date + difference }
  let(:difference) { 1.year }

  context 'when other object is a date' do
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

  context 'when other date is a time' do
    let(:other_date) { subject.to_date.to_time + difference }

    context 'when other date is one year and 10 hours ahead' do
      let(:difference) { 1.year + 10.hours }
      it { expect(subject.days_between(other_date)).to eq(365) }
    end

    context 'when other date is one year and 25 hours ahead' do
      let(:difference) { 1.year + 25.hours }
      it { expect(subject.days_between(other_date)).to eq(366) }
    end

    context 'when other date is one year and 23 hours ahead' do
      let(:difference) { 1.year + 23.hours }
      it { expect(subject.days_between(other_date)).to eq(365) }
    end

    context 'when other date is one year and 10 hours behind' do
      let(:difference) { - 1.year - 10.hours }
      it { expect(subject.days_between(other_date)).to eq(366) }
    end

    context 'when other date is almost one year behind (missing 10 hours)' do
      let(:difference) { -1.year + 10.hours }
      it { expect(subject.days_between(other_date)).to eq(365) }
    end
  end
end
