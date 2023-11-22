require 'rails_helper'

describe Representative do
  describe '.civic_api_to_representative_params' do
    let(:rep_info) { double('rep_info', officials: officials, offices: offices) }
    let(:officials) { [double('official1', name: 'John Doe'), double('official2', name: 'Jane Smith')] }
    let(:offices) { [double('office1', official_indices: [0]), double('office2', official_indices: [1])] }

    it 'creates representatives based on civic API information' do
      expect(Representative).to receive(:create!).with({ name: 'John Doe', ocdid: 'office1_ocdid', title: 'office1_name' })
      expect(Representative).to receive(:create!).with({ name: 'Jane Smith', ocdid: 'office2_ocdid', title: 'office2_name' })

      Representative.civic_api_to_representative_params(rep_info)
    end

    it 'returns an array of created representatives' do
      representatives = Representative.civic_api_to_representative_params(rep_info)
      expect(representatives).to be_an(Array)
      expect(representatives.size).to eq(2)
      expect(representatives.all? { |rep| rep.is_a?(Representative) }).to be_truthy
    end

    # Add more specific tests as needed based on your application's requirements
  end
end