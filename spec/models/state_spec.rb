require 'rails_helper'

RSpec.describe State, type: :model do
  describe '#std_fips_code' do
    it 'returns a standardized FIPS code with leading zeros' do
      # Create a State instance with a FIPS code
      state = State.new(fips_code: 6)

      # Call the method being tested
      std_fips_code = state.std_fips_code

      # Assertion
      expect(std_fips_code).to eq('06')
    end

    it 'returns a standardized FIPS code for a single-digit code' do
      # Create a State instance with a single-digit FIPS code
      state = State.new(fips_code: 2)

      # Call the method being tested
      std_fips_code = state.std_fips_code

      # Assertion
      expect(std_fips_code).to eq('02')
    end

    # Add more tests as needed to cover different scenarios.
  end

  # You can add more tests for other methods in the State model if needed.
end