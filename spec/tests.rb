# frozen_string_literal: true

require 'rails_helper'
# Test for representative.rb:
RSpec.describe Representative, type: :model do
  describe '.civic_api_to_representative_params' do
    let(:rep_info) do
      OpenStruct.new(
        officials: [OpenStruct.new(
          name:    'Sep',
          address: [OpenStruct.new(
            line1: '123 Piedmont',
            state: 'CA',
            zip:   '94704'
          )]
        )],
        offices:   [OpenStruct.new(
          name:             'Mayor',
          division_id:      '123',
          official_indices: [0]
        )]
      )
    end

    it 'does not create a new representative if one already exists with the same ocdid' do
      existing_rep = Representative.create!(name: 'Existing Rep', ocdid: '123', title: 'Mayor')

      expect do
        Representative.civic_api_to_representative_params(rep_info)
      end.not_to change(Representative, :count)

      existing_rep.reload

      expect(existing_rep.name).to eq('Sep')
      expect(existing_rep.title).to eq('Mayor')
    end
  end
end

# Tests for AjaxController:

RSpec.describe AjaxController, type: :controller do
  let(:state) { create(:state) }
  let(:counties) { create_list(:county, 3, state: state) }

  describe 'GET #counties' do
    it 'returns a JSON array of counties for the provided state symbol' do
      get :counties, params: { state_symbol: state.symbol.downcase }

      expected_response = counties.map do |county|
        {
          'id'       => county.id,
          'name'     => county.name,
          'state_id' => county.state_id
        }
      end

      expect(response.body).to eq(expected_response.to_json)
    end

    it 'returns a 404 response when state symbol is not found' do
      get :counties, params: { state_symbol: 'invalid-symbol' }
      expect(response).to have_http_status(:not_found)
    end
  end
end
