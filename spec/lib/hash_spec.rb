require 'spec_helper'

describe Hash do
  it_behaves_like 'a class with change_key method'
  it_behaves_like 'a class with camlize_keys method'

  describe :squash do
    let(:hash) { { a: { b: 1, c: { d: 2 } } } }

    it 'flattens the hash' do
      expect(hash.squash).to eq({ 'a.b' => 1, 'a.c.d' => 2 })
    end

    it { expect { hash.squash }.not_to change { hash } }

    context 'with array value' do
      let(:hash) { { a: { b: [1, { x: 3, y: { z: 4 } }] } } }

      it 'flattens the hash' do
        expect(hash.squash).to eq({ 'a.b' => [1, { x: 3, y: { z: 4 } }] })
      end
    end
  end

  describe :prepend_to_keys do
    it 'accepts block to change the keys' do
      { a: 1, 'b' => 2 }.prepend_to_keys('foo_').should eq({ foo_a: 1, 'foo_b' => 2 })
    end
    it 'applies the block recursively' do
      { 'a' => 1, b:  { c: 3, 'd' => 4 } }.prepend_to_keys('foo_').should eq({ 'foo_a' => 1, foo_b:  { foo_c: 3, 'foo_d' => 4 } })
    end
    it 'changes type when type option is passed' do
      { 'a' => 1, b: 2 }.prepend_to_keys('foo_', type: :string).should eq({ 'foo_a' => 1, 'foo_b' => 2 })
    end
    it 'changes type when type option is passed' do
      { 'a' => 1, b: 2 }.prepend_to_keys('foo_', type: :symbol).should eq({ foo_a: 1, foo_b: 2 })
    end
    it 'keep type when type option is passed as keep' do
      { 'a' => 1, b: 2 }.prepend_to_keys('foo_', type: :keep).should eq({ 'foo_a' => 1, foo_b: 2 })
    end
    it 'applies to array as well' do
      { 'a' => 1, b: [{ c: 2 }, { d: 3 }] }.prepend_to_keys('foo_', type: :keep).should eq({ 'foo_a' => 1, foo_b: [{ foo_c: 2 }, { foo_d: 3 }] })
    end
  end

  describe :append_to_keys do
    it 'accepts block to change the keys' do
      { a: 1, 'b' => 2 }.append_to_keys('_bar').should eq({ a_bar: 1, 'b_bar' => 2 })
    end
    it 'applies the block recursively' do
      { 'a' => 1, b:  { c: 3, 'd' => 4 } }.append_to_keys('_bar').should eq({ 'a_bar' => 1, b_bar:  { c_bar: 3, 'd_bar' => 4 } })
    end
    it 'changes type when type option is passed' do
      { 'a' => 1, b: 2 }.append_to_keys('_bar', type: :string).should eq({ 'a_bar' => 1, 'b_bar' => 2 })
    end
    it 'changes type when type option is passed' do
      { 'a' => 1, b: 2 }.append_to_keys('_bar', type: :symbol).should eq({ a_bar: 1, b_bar: 2 })
    end
    it 'keep type when type option is passed as keep' do
      { 'a' => 1, b: 2 }.append_to_keys('_bar', type: :keep).should eq({ 'a_bar' => 1, b_bar: 2 })
    end
    it 'applies to array as well' do
      { 'a' => 1, b: [{ c: 2 }, { d: 3 }] }.append_to_keys('_bar', type: :keep).should eq({ 'a_bar' => 1, b_bar: [{ c_bar: 2 }, { d_bar: 3 }] })
    end
  end

  describe :sort_keys do
    it 'sorts keys as symbols' do
      { b: 1, a: 2 }.sort_keys.should eq({ a: 2, b: 1 })
    end
    it 'sorts keys as string' do
      { 'b' => 1, 'a' => 2 }.sort_keys.should eq({ 'a' => 2, 'b' => 1 })
    end
    it 'sorts keys recursively' do
      { b: 1, a: { d: 3, c: 4 } }.sort_keys.should eq({ a: { c: 4, d: 3 }, b: 1 })
    end
    it 'sorts keys recursively when argumen is passed' do
      { b: 1, a: { d: 3, c: 4 } }.sort_keys({ recursive: true }).should eq({ a: { c: 4, d: 3 }, b: 1 })
    end
    it 'does not sorts keys recursively when argumen is passed' do
      { b: 1, a: { d: 3, c: 4 } }.sort_keys({ recursive: false }).should eq({ a: { d: 3, c: 4 }, b: 1 })
    end
    it 'sort recursevely on many levels' do
      hash = { b: 1, a: { d: 2, c: { e: 3, f: 4 } } }
      expected = { a: { c: { f: 4, e: 3 }, d: 2 }, b: 1 }
      hash.sort_keys({ recursive: true }).should eq(expected)
    end
    it 'applies to arrays as well' do
      hash = { b: 1, a: { d: 2, c: [{ e: 3, f: 4 }] } }
      expected = { a: { c: [{ f: 4, e: 3 }], d: 2 }, b: 1 }
      hash.sort_keys({ recursive: true }).should eq(expected)
    end
  end

  describe :change_values do
    let(:subject) { { a: 1, b: 2, c: { d: 3, e: 4 } } }
    it 'updates values of hash' do
      subject.change_values { |value| value + 1 }.should eq({ a: 2, b: 3, c: { d: 4, e: 5 } })
    end
    it 'does not change original hash' do
      subject.change_values { |value| value + 1 }
      expect(subject).to eq({ a: 1, b: 2, c: { d: 3, e: 4 } })
    end
    it 'works recursively when parameter is passed' do
      subject.change_values(recursive: true) { |value| value + 1 }.should eq({ a: 2, b: 3, c: { d: 4, e: 5 } })
    end
    it 'does not work recursively when parameter is passed as false' do
      subject.change_values(recursive: false) { |value| value + 1 }.should eq({ a: 2, b: 3, c: { d: 3, e: 4 } })
    end
    it 'does not ignore hash when option is passed' do
      subject.change_values(skip_inner: false) { |value| value.is_a?(Hash) ? 10 + value.size : value + 1 }.should eq({ a: 2, b: 3, c: 12 })
    end
    it 'ignore hash and work recursively when option is passed' do
      subject.change_values(skip_inner: false) { |value| value.is_a?(Hash) ? value : value + 1 }.should eq({ a: 2, b: 3, c: { d: 4, e: 5 } })
    end
    it 'ignore hash and does not work recursively when option is passed' do
      subject.change_values(skip_inner: false, recursive: false) { |value| value.is_a?(Hash) ? value : value + 1 }.should eq({ a: 2, b: 3, c: { d: 3, e: 4 } })
    end
    it 'applies to arrays as well' do
      subject = { a: 1, b: 2, c: [{ d: 3 }, { e: 4 }] }
      subject.change_values { |value| value + 1 }.should eq({ a: 2, b: 3, c: [{ d: 4 }, { e: 5 }] })
    end
    it 'should call change_values!' do
      original = { 'a' => 1, c: { d: 3, e: 4 } }
      copy = { 'a' => 1, c: { d: 3, e: 4 } }

      expect(original).to receive(:deep_dup).and_return(copy)
      expect(copy).to receive(:change_values!)
      original.change_values { |value| value + 1 }
    end
  end

  describe :change_values! do
    let(:subject) { { a: 1, b: 2, c: { d: 3, e: 4 } }  }

    it 'changes original hash' do
      subject.change_values! { |value| value + 1 }

      expect(subject).to_not eq({ a: 1, b: 2, c: { d: 3, e: 4 } })
      expect(subject).to eq({ a: 2, b: 3, c: { d: 4, e: 5 } })
    end
  end

  describe :to_deep_hash do
    let(:subject) do
      {
        'person.name' => 'Some name',
        'person.age' => 22,
        'status' => :success,
        'vehicle.fuel' => 'GASOLINE',
        'vehicle.doors' => 4
      }
    end

    let(:expected) do
      {
        'person' => { 'name' => 'Some name', 'age' => 22 },
        'vehicle' => { 'fuel' => 'GASOLINE', 'doors' => 4 },
        'status' => :success
      }
    end

    it 'build a deep hash' do
      expect(subject.to_deep_hash).to eq(expected)
    end

    context 'with indexed keys' do
      let(:subject) do
        {
          'person[0].name' => 'First person',
          'person[0].age' => 22,
          'person[1].name' => 'Second person',
          'person[1].age' => 27,
          'device[0]' => 'GEAR_LOCK',
          'device[1]' => 'GPS',
          'zipCode' => '122345-123'
        }
      end

      let(:expected) do
        {
          'person' => [
            { 'name' => 'First person', 'age' => 22 },
            { 'name' => 'Second person', 'age' => 27 }
          ],
          'device' => %w(GEAR_LOCK GPS),
          'zipCode' => '122345-123'
        }
      end

      it 'build a deep hash with arrays' do
        expect(subject.to_deep_hash).to eq(expected)
      end
    end

    context 'with a n level hash' do
      let(:subject) do
        {
          'quote_request.personal.person.name' => 'Some name',
          'quote_request.personal.person.age' => 22,
          'quote_request.insurance.vehicle.fuel' => 'GASOLINE',
          'quote_request.insurance.vehicle.doors' => 4,
          'request.status' => :success,
          'trials' => 3
        }
      end

      let(:expected) do
        {
          'quote_request' => {
            'personal' => {
              'person' => { 'name' => 'Some name', 'age' => 22 }
            },
            'insurance' => {
              'vehicle' => { 'fuel' => 'GASOLINE', 'doors' => 4 }
            }
          },
          'request' => { 'status' => :success },
          'trials' => 3
        }
      end

      it 'build a deep hash with arrays' do
        expect(subject.to_deep_hash).to eq(expected)
      end
    end

    context 'with a n level hash and arrays' do
      let(:subject) do
        {
          'quote_request.personal.person[0].name' => 'Some name 1',
          'quote_request.personal.person[0].age' => 22,
          'quote_request.personal.person[1].name' => 'Some name 2',
          'quote_request.personal.person[1].age' => 23,
          'request[0].status.clazz' => String,
          'request[1].status.clazz' => Fixnum,
          'request[2].status.clazz' => Date,
          'trials' => 3
        }
      end

      let(:expected) do
        {
          'quote_request' => {
            'personal' => {
              'person' => [
                { 'name' => 'Some name 1', 'age' => 22 },
                { 'name' => 'Some name 2', 'age' => 23 }
              ]
            }
          },
          'request' => [
            { 'status' => { 'clazz' => String } },
            { 'status' => { 'clazz' => Fixnum } },
            { 'status' => { 'clazz' => Date } }
          ],
          'trials' => 3
        }
      end

      it 'build a deep hash with arrays' do
        expect(subject.to_deep_hash).to eq(expected)
      end
    end

    context 'with custom separator' do
      let(:subject) do
        {
          'person_name' => 'Some name',
          'person_age' => 22,
          'status' => :success,
          'vehicle_fuel' => 'GASOLINE',
          'vehicle_doors' => 4
        }
      end

      it 'build a deep hash with arrays' do
        expect(subject.to_deep_hash('_')).to eq(expected)
      end
    end

    context 'with custom separator on n level deep hash' do
      let(:subject) do
        {
          'person_name_clazz' => String
        }
      end

      let(:expected) do
        {
          'person' => {
            'name' => { 'clazz' => String }
          }
        }
      end

      it 'build a deep hash with arrays' do
        expect(subject.to_deep_hash('_')).to eq(expected)
      end
    end
  end

  describe '#map_and_find' do
    let(:hash) { { a: 1, b: 2, c: 3, d: 4} }
    let(:value) { hash.map_and_find(&block) }

    context 'when block returns nil' do
      let(:block) { Proc.new {} }
      it { expect(value).to be_nil }
    end

    context 'when block returns false' do
      let(:block) { Proc.new { false } }
      it { expect(value).to be_nil }
    end

    context 'when block returns a true evaluated value' do
      let(:block) { Proc.new { |k, v| v.to_s } }

      it { expect(value).to eq('1') }

      context 'but not for the first value' do
        let(:transformer) { double(:transformer) }
        let(:block) { Proc.new { |k, v| transformer.transform(v) } }

        before do
          allow(transformer).to receive(:transform) do |v|
            v.to_s if v > 1
          end
          value
        end

        it { expect(value).to eq('2') }
        it 'calls the mapping only until it returns a valid value' do
          expect(transformer).to have_received(:transform).exactly(2)
        end
      end
    end

    context 'when the block accepts one argument' do
      let(:block) { Proc.new { |v| v } }

      it do
        expect(value).to eq([:a, 1])
      end
    end
  end
end
