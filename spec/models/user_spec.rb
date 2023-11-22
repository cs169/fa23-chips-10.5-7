require 'rails_helper'

RSpec.describe User, type: :model do
  describe '.find_google_user' do
    it 'finds a user by UID and provider (Google)' do
      # Mocking the database query
      allow(User).to receive(:find_by).with(provider: User.providers[:google_oauth2], uid: 'some_uid').and_return(User.new)

      # Call the method being tested
      user = User.find_google_user('some_uid')

      # Assertion
      expect(user).to be_instance_of(User)
    end
  end

  describe '.find_github_user' do
    it 'finds a user by UID and provider (GitHub)' do
      # Mocking the database query
      allow(User).to receive(:find_by).with(provider: User.providers[:github], uid: 'some_uid').and_return(User.new)

      # Call the method being tested
      user = User.find_github_user('some_uid')

      # Assertion
      expect(user).to be_instance_of(User)
    end
  end

  # You can add more tests for other methods in the User model if needed.
end