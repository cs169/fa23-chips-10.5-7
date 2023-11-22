require 'rails_helper'

RSpec.describe Event, type: :model do
  describe 'associations' do
    it { should belong_to(:county) }
  end

  describe 'validations' do
    it { should validate_presence_of(:start_time) }
    it { should validate_presence_of(:end_time) }

    it 'validates that start time must be after today' do
      event = Event.new(start_time: Time.zone.now - 1.day)
      expect(event).to be_invalid
    end

    it 'validates that end time must be after start time' do
      event = Event.new(start_time: Time.zone.now, end_time: Time.zone.now - 1.day)
      expect(event).to be_invalid
    end
  end

  describe 'delegation' do
    it { should delegate_method(:state).to(:county).allow_nil }
  end

  describe '#county_names_by_id' do
    it 'returns a hash of county names by ID' do
      state = create(:state)
      county = create(:county, state: state)
      event = create(:event, county: county)

      expect(event.county_names_by_id).to eq({ county.name => county.id })
    end
  end
end