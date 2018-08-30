# frozen_string_literal: true

shared_examples 'a class with underscore_keys method basic' do |method|
  describe :underscore_keys do
    let(:expected) { { input_key: 'value' } }

    context 'with camel case keys' do
      let(:hash) { { inputKey: 'value' } }

      it 'converts the keys to snake case' do
        expect(hash.send(method)).to eq(expected)
      end
    end

    context 'with string keys' do
      let(:expected) { { 'input_key' => 'value' } }
      let(:hash) { { 'InputKey' => 'value' } }

      it 'converts the keys to snake case' do
        expect(hash.send(method)).to eq(expected)
      end
    end

    context 'with deep keys change' do
      let(:expected) { { input_key: { inner_key: 'value' } } }
      let(:hash) { { InputKey: { InnerKey: 'value' } } }

      it 'converts the keys to snake case' do
        expect(hash.send(method)).to eq(expected)
      end
    end

    context 'with array keys change' do
      let(:expected) { { input_key: [{ inner_key: 'value' }] } }
      let(:hash) { { InputKey: [{ InnerKey: 'value' }] } }

      it 'converts the keys to snake case' do
        expect(hash.send(method)).to eq(expected)
      end
    end

    context 'without recursive options' do
      context 'with deep keys change' do
        let(:expected) { { input_key: { InnerKey: 'value' } } }
        let(:hash) { { InputKey: { InnerKey: 'value' } } }

        it 'converts the keys to lower camel case' do
          expect(hash.send(method, recursive: false)).to eq(expected)
        end
      end

      context 'with array keys change' do
        let(:expected) { { input_key: [{ InnerKey: 'value' }] } }
        let(:hash) { { InputKey: [{ InnerKey: 'value' }] } }

        it 'converts the keys to camle case' do
          expect(hash.send(method, recursive: false)).to eq(expected)
        end
      end
    end
  end
end

shared_examples 'a class with underscore_keys! method' do
  let(:hash) { { inputKey: 'value' } }

  it_behaves_like 'a class with underscore_keys method basic', :underscore_keys!

  it 'changes original hash' do
    expect { hash.underscore_keys! }.to(change { hash })
  end
end

shared_examples 'a class with underscore_keys method' do
  let(:hash) { { inputKey: 'value' } }

  it_behaves_like 'a class with underscore_keys method basic', :underscore_keys
  it_behaves_like 'a class with underscore_keys! method'

  it 'does not change original hash' do
    expect { hash.underscore_keys }.not_to(change { hash })
  end
end
