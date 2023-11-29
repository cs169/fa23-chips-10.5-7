
# frozen_string_literal: true
require 'ostruct'
require 'rails_helper'

describe Representative, type: :model do
  let(:rep_info) do
    OpenStruct.new(
      officials: [
        OpenStruct.new(name:    'Bill Smith',
                       address: [OpenStruct.new(locationName: 'Location 1', line1: 'Address 1',
                                                city: 'City 1', state: 'State 1',
                                                zip: '12345')]),
        OpenStruct.new(name:    'Jacob Willows',
                       address: [OpenStruct.new(locationName: 'Location 2', line1: 'Address 2',
                                                city: 'City 2', state: 'State 2',
                                                zip: '67890')])
      ],
      offices:   [
        OpenStruct.new(name: 'Office1', division_id: '1', official_indices: [0, 1])
      ]
    )
  end

  before do
    described_class.create!(name: 'Bill Smith', ocdid: '1', title: 'Office1')
  end

  it 'creates representatives without errors for duplicate input' do
    expect do
      described_class.civic_api_to_representative_params(rep_info)
    end.not_to raise_error
  end

  it 'finds Bill Smith in the database' do
    described_class.civic_api_to_representative_params(rep_info)
    expect(described_class.find_by(name: 'Bill Smith')).not_to be_nil
  end

  it 'finds Jacob Willows in the database' do
    described_class.civic_api_to_representative_params(rep_info)
    expect(described_class.find_by(name: 'Jacob Willows')).not_to be_nil
  end

  it 'has a count of 2 in the database' do
    described_class.civic_api_to_representative_params(rep_info)
    expect(described_class.count).to eq(2)
  end
end
