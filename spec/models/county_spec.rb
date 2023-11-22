require 'rails_helper'

RSpec.describe County, type: :model do
  describe 'associations' do
    it { should belong_to(:state) }
  end

  describe '#std_fips_code' do
    it 'returns the standardized FIPS code' do
      county = County.new(fips_code: 1)
      expect(county.std_fips_code).to eq('001')
    end
  end
end