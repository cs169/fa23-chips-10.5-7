require 'rails_helper'

describe Representative, type: :model do
  describe '.civic_api_to_representative_params' do 
    it 'creates representatives without errors for duplicate input' do 
      rep_info = double('rep_info', 
        officials: [
          double('official', name: 'Bill Smith'),
          double('official', name: 'Jacob Willows')
        ],
        offices: [
          double('office', name: 'Office1', division_id: '1', official_indices: [0, 1]),
        ]
      )

      #create representative with same name to check if it errors or not (it shouldn't)
      Representative.create!(name: 'Bill Smith', ocdid: '1', title: 'Office1')

      expect {
        Representative.civic_api_to_representative_params(rep_info)
      }.not_to raise_error

      expect(Representative.find_by(name: 'Bill Smith')).not_to be_nil

      expect(Representative.find_by(name: 'Jacob Willows')).not_to be_nil

      expect(Representative.count).to eq(2)
    end
  end
end 

      