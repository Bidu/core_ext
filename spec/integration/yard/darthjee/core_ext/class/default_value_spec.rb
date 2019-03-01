# frozen_string_literal: false

require 'spec_helper'

describe Class do
  describe 'yard' do
    subject(:instance) { klass.new }

    describe '#default_value' do
      let(:klass) do
        Class.new do
          default_value :name, 'John'
        end
      end

      context 'when calling method' do
        it 'returns the same value always' do
          expect(instance.name).to eq('John')
        end

        it 'returns the same instance accros instances of the class' do
          expect(instance.name).not_to be_equal('John')
          expect(instance.name).to be_equal(klass.new.name)
        end
      end
    end

    describe '#default_values' do
      let(:klass) do
        Class.new do
          default_values :name, :nick_name, 'John'
        end
      end

      context 'when calling method' do
        it 'returns the same value always for first method' do
          expect(instance.name).to eq('John')
        end

        it 'returns the same value always for second method' do
          expect(instance.nick_name).to eq('John')
        end

        it 'returns the same instance accros instances of the class' do
          expect(instance.name).not_to be_equal('John')
          expect(instance.name).to be_equal(klass.new.name)
        end

        it 'returns the same instance for all methods' do
          expect(instance.nick_name).not_to be_equal('John')
          expect(instance.name).to be_equal(instance.nick_name)
        end
      end
    end

    describe '#default_reader' do
      let(:klass) do
        Class.new do
          attr_writer :name
          default_reader :name, 'John Doe'
        end
      end

      context 'when calling method' do
        it 'returns the default value' do
          expect(instance.name).to eq('John Doe')
        end

        context 'when setting the variable' do
          before { instance.name = 'Joe' }

          it 'returns the new value' do
            expect(instance.name).to eq('Joe')
          end
        end

        context 'when setting the variable to be nil' do
          before { instance.name = nil }

          it 'returns nil' do
            expect(instance.name).to be_nil
          end
        end
      end
    end
  end
end
