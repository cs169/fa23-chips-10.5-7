require 'rails_helper'
RSpec.describe Representative, type: :model do
  describe '.civic_api_to_representative_params' do 
    it 'creates representatives without errors for duplicate input' do 
      rep_info = double('rep_info', 
        officials: [
          double('official', name: 'Bill Smith', address: [double('address', locationName: '123 Flame Ave', line1: 'Apt 1', line2: '', line3: '', city: 'Perris', state: 'CA', zip: '12345')], party: 'Party', photoUrl: "url"),
          double('official', name: 'Hannah Smith', address: [double('address', locationName: '123 Flame Ave', line1: 'Apt 1', line2: '', line3: '', city: 'Perris', state: 'CA', zip: '12345')], party: 'Party', photoUrl: "url"),

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

      expect(Representative.count).to eq(2)

  
    end
  end
end 

      