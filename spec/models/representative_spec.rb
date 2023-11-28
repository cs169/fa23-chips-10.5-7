# frozen_string_literal: true

require 'rails_helper'

describe Representative, type: :model do
  describe '.civic_api_to_representative_params' do
    before do
      described_class.create!(name: 'Bill Smith', ocdid: '1', title: 'Office1')
    end

    let(:rep_info) do
      instance_double(RepInfo,
                      officials: [
                        instance_double(Official, name: 'Bill Smith'),
                        instance_double(Official, name: 'Jacob Willows')
                      ],
                      offices:   [
                        instance_double(Office, name: 'Office1', division_id: '1', official_indices: [0, 1])
                      ])
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
end
