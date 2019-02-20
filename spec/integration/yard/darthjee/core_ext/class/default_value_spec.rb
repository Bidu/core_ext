# frozen_string_literal: false

require 'spec_helper'

describe Class do
  describe 'yard' do
    describe '#default_value' do
      subject { klass.new }

      let(:klass) do
        Class.new do
          default_value :name, 'John'
        end
      end

      context 'when calling method' do
        it 'returns the same value always' do
          expect(subject.name).to eq('John')
        end

        it 'returns the same instance accros instances of the class' do
          expect(subject.name).not_to be_equal('John')
          expect(subject.name).to be_equal(klass.new.name)
        end
      end
    end

    describe '#default_values' do
      subject { klass.new }

      let(:klass) do
        Class.new do
          default_values :name, :nick_name, 'John'
        end
      end

      context 'when calling method' do
        it 'returns the same value always for first method' do
          expect(subject.name).to eq('John')
        end

        it 'returns the same value always for second method' do
          expect(subject.nick_name).to eq('John')
        end

        it 'returns the same instance accros instances of the class' do
          expect(subject.name).not_to be_equal('John')
          expect(subject.name).to be_equal(klass.new.name)
        end

        it 'returns the same instance for all methods' do
          expect(subject.nick_name).not_to be_equal('John')
          expect(subject.name).to be_equal(subject.nick_name)
        end
      end
    end
  end
end
