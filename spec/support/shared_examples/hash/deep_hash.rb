# frozen_string_literal: true

shared_examples 'a method that returns a deep hash' do
  subject(:hash) do
    {
      'person.name' => 'Some name',
      'person.age' => 22,
      'status' => :success,
      'vehicle.fuel' => 'GASOLINE',
      'vehicle.doors' => 4
    }
  end

  let(:args) { [] }

  let(:expected) do
    {
      'person' => { 'name' => 'Some name', 'age' => 22 },
      'vehicle' => { 'fuel' => 'GASOLINE', 'doors' => 4 },
      'status' => :success
    }
  end

  it 'build a deep hash' do
    expect(result).to eq(expected)
  end

  context 'with indexed keys' do
    subject(:hash) do
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
        'device' => %w[GEAR_LOCK GPS],
        'zipCode' => '122345-123'
      }
    end

    it 'build a deep hash with arrays' do
      expect(result).to eq(expected)
    end
  end

  context 'with a n level hash' do
    subject(:hash) do
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
      expect(result).to eq(expected)
    end
  end

  context 'with a n level hash and arrays' do
    subject(:hash) do
      {
        'quote_request.personal.person[0].name' => 'Some name 1',
        'quote_request.personal.person[0].age' => 22,
        'quote_request.personal.person[1].name' => 'Some name 2',
        'quote_request.personal.person[1].age' => 23,
        'request[0].status.clazz' => 'String',
        'request[1].status.clazz' => 'Integer',
        'request[2].status.clazz' => 'Date',
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
          { 'status' => { 'clazz' => 'String' } },
          { 'status' => { 'clazz' => 'Integer' } },
          { 'status' => { 'clazz' => 'Date' } }
        ],
        'trials' => 3
      }
    end

    it 'build a deep hash with arrays' do
      expect(result).to eq(expected)
    end
  end

  context 'with custom separator' do
    subject(:hash) do
      {
        'person_name' => 'Some name',
        'person_age' => 22,
        'status' => :success,
        'vehicle_fuel' => 'GASOLINE',
        'vehicle_doors' => 4
      }
    end

    let(:args) { ['_'] }

    it 'build a deep hash with arrays' do
      expect(result).to eq(expected)
    end
  end

  context 'with custom separator on n level deep hash' do
    subject(:hash) do
      {
        'person_name_clazz' => 'String'
      }
    end

    let(:args) { ['_'] }

    let(:expected) do
      {
        'person' => {
          'name' => { 'clazz' => 'String' }
        }
      }
    end

    it 'build a deep hash with arrays' do
      expect(result).to eq(expected)
    end
  end
end
