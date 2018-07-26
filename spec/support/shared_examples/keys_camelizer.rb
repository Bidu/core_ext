# frozen_string_literal: true

shared_examples 'a class with camlize_keys method' do
  describe :lower_camelize_keys do
    let(:expected) { { inputKey: 'value' } }

    context 'with underscore keys' do
      let(:hash) { { input_key: 'value' } }

      it 'converts the keys to lower camel case' do
        expect(hash.lower_camelize_keys).to eq(expected)
      end

      it 'does not change original hash' do
        expect { hash.lower_camelize_keys }.not_to change { hash }
      end
    end

    context 'with camel case keys' do
      let(:hash) { { InputKey: 'value' } }

      it 'converts the keys to lower camel case' do
        expect(hash.lower_camelize_keys).to eq(expected)
      end
    end

    context 'with string keys' do
      let(:expected) { { 'inputKey' => 'value' } }
      let(:hash) { { 'InputKey' => 'value' } }

      it 'converts the keys to lower camel case' do
        expect(hash.lower_camelize_keys).to eq(expected)
      end
    end

    context 'with deep keys change' do
      let(:expected) { { inputKey: { innerKey: 'value' } } }
      let(:hash) { { InputKey: { InnerKey: 'value' } } }

      it 'converts the keys to lower camel case' do
        expect(hash.lower_camelize_keys).to eq(expected)
      end
    end

    context 'with array keys change' do
      let(:expected) { { inputKey: [{ innerKey: 'value' }] } }
      let(:hash) { { InputKey: [{ InnerKey: 'value' }] } }

      it 'converts the keys to camle case' do
        expect(hash.lower_camelize_keys).to eq(expected)
      end
    end

    context 'without recursive options' do
      context 'with deep keys change' do
        let(:expected) { { inputKey: { InnerKey: 'value' } } }
        let(:hash) { { InputKey: { InnerKey: 'value' } } }

        it 'converts the keys to lower camel case' do
          expect(hash.lower_camelize_keys(recursive: false)).to eq(expected)
        end
      end

      context 'with array keys change' do
        let(:expected) { { inputKey: [{ InnerKey: 'value' }] } }
        let(:hash) { { InputKey: [{ InnerKey: 'value' }] } }

        it 'converts the keys to camle case' do
          expect(hash.lower_camelize_keys(recursive: false)).to eq(expected)
        end
      end
    end
  end

  describe :lower_camelize_keys! do
    let(:expected) { { inputKey: 'value' } }

    context 'with underscore keys' do
      let(:hash) { { input_key: 'value' } }

      it 'converts the keys to lower camel case' do
        expect(hash.lower_camelize_keys!).to eq(expected)
      end

      it 'does not change original hash' do
        expect { hash.lower_camelize_keys! }.to change { hash }
      end
    end

    context 'with camel case keys' do
      let(:hash) { { InputKey: 'value' } }

      it 'converts the keys to lower camel case' do
        expect(hash.lower_camelize_keys!).to eq(expected)
      end
    end

    context 'with string keys' do
      let(:expected) { { 'inputKey' => 'value' } }
      let(:hash) { { 'InputKey' => 'value' } }

      it 'converts the keys to lower camel case' do
        expect(hash.lower_camelize_keys).to eq(expected)
      end
    end

    context 'with deep keys change' do
      let(:expected) { { inputKey: { innerKey: 'value' } } }
      let(:hash) { { InputKey: { InnerKey: 'value' } } }

      it 'converts the keys to lower camel case' do
        expect(hash.lower_camelize_keys!).to eq(expected)
      end
    end

    context 'with array keys change' do
      let(:expected) { { inputKey: [{ innerKey: 'value' }] } }
      let(:hash) { { InputKey: [{ InnerKey: 'value' }] } }

      it 'converts the keys to camle case' do
        expect(hash.lower_camelize_keys!).to eq(expected)
      end
    end

    context 'without recursive options' do
      context 'with deep keys change' do
        let(:expected) { { inputKey: { InnerKey: 'value' } } }
        let(:hash) { { InputKey: { InnerKey: 'value' } } }

        it 'converts the keys to lower camel case' do
          expect(hash.lower_camelize_keys!(recursive: false)).to eq(expected)
        end
      end

      context 'with array keys change' do
        let(:expected) { { inputKey: [{ InnerKey: 'value' }] } }
        let(:hash) { { InputKey: [{ InnerKey: 'value' }] } }

        it 'converts the keys to camle case' do
          expect(hash.lower_camelize_keys!(recursive: false)).to eq(expected)
        end
      end
    end
  end

  describe :camelize_keys do
    let(:expected) { { InputKey: 'value' } }

    context 'with underscore keys' do
      let(:hash) { { input_key: 'value' } }

      it 'converts the keys to camel case' do
        expect(hash.camelize_keys).to eq(expected)
      end

      it 'does not change original hash' do
        expect { hash.camelize_keys }.not_to change { hash }
      end
    end

    context 'with lower camel case keys' do
      let(:hash) { { inputKey: 'value' } }

      it 'converts the keys to camle case' do
        expect(hash.camelize_keys).to eq(expected)
      end
    end

    context 'with string keys' do
      let(:expected) { { 'InputKey' => 'value' } }
      let(:hash) { { 'inputKey' => 'value' } }

      it 'converts the keys to lower camel case' do
        expect(hash.camelize_keys).to eq(expected)
      end
    end

    context 'with deep keys change' do
      let(:expected) { { InputKey: { InnerKey: 'value' } } }
      let(:hash) { { inputKey: { innerKey: 'value' } } }

      it 'converts the keys to camle case' do
        expect(hash.camelize_keys).to eq(expected)
      end
    end

    context 'with array keys change' do
      let(:expected) { { InputKey: [{ InnerKey: 'value' }] } }
      let(:hash) { { inputKey: [{ innerKey: 'value' }] } }

      it 'converts the keys to camle case' do
        expect(hash.camelize_keys).to eq(expected)
      end
    end

    context 'without recursive options' do
      context 'with deep keys change' do
        let(:expected) { { InputKey: { InnerKey: 'value' } } }
        let(:hash) { { inputKey: { InnerKey: 'value' } } }

        it 'converts the keys to lower camel case' do
          expect(hash.camelize_keys(recursive: false)).to eq(expected)
        end
      end

      context 'with array keys change' do
        let(:expected) { { InputKey: [{ InnerKey: 'value' }] } }
        let(:hash) { { inputKey: [{ InnerKey: 'value' }] } }

        it 'converts the keys to camle case' do
          expect(hash.camelize_keys(recursive: false)).to eq(expected)
        end
      end
    end
  end

  describe :camelize_keys! do
    let(:expected) { { InputKey: 'value' } }

    context 'with underscore keys' do
      let(:hash) { { input_key: 'value' } }

      it 'converts the keys to camel case' do
        expect(hash.camelize_keys!).to eq(expected)
      end

      it 'does not change original hash' do
        expect { hash.camelize_keys! }.to change { hash }
      end
    end

    context 'with lower camel case keys' do
      let(:hash) { { inputKey: 'value' } }

      it 'converts the keys to camle case' do
        expect(hash.camelize_keys!).to eq(expected)
      end
    end

    context 'with string keys' do
      let(:expected) { { 'InputKey' => 'value' } }
      let(:hash) { { 'inputKey' => 'value' } }

      it 'converts the keys to lower camel case' do
        expect(hash.camelize_keys!).to eq(expected)
      end
    end

    context 'with deep keys change' do
      let(:expected) { { InputKey: { InnerKey: 'value' } } }
      let(:hash) { { inputKey: { innerKey: 'value' } } }

      it 'converts the keys to camle case' do
        expect(hash.camelize_keys!).to eq(expected)
      end
    end

    context 'with array keys change' do
      let(:expected) { { InputKey: [{ InnerKey: 'value' }] } }
      let(:hash) { { inputKey: [{ innerKey: 'value' }] } }

      it 'converts the keys to camle case' do
        expect(hash.camelize_keys!).to eq(expected)
      end
    end

    context 'without recursive options' do
      context 'with deep keys change' do
        let(:expected) { { InputKey: { InnerKey: 'value' } } }
        let(:hash) { { inputKey: { InnerKey: 'value' } } }

        it 'converts the keys to lower camel case' do
          expect(hash.camelize_keys!(recursive: false)).to eq(expected)
        end
      end

      context 'with array keys change' do
        let(:hash) { { inputKey: [{ InnerKey: 'value' }] } }
        let(:expected) { { InputKey: [{ InnerKey: 'value' }] } }

        it 'converts the keys to camle case' do
          expect(hash.camelize_keys!(recursive: false)).to eq(expected)
        end
      end
    end
  end
end
