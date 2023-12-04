# frozen_string_literal: true

require 'rails_helper'
# Tests for LoginController:

RSpec.describe LoginController, type: :controller do
  let(:user) { create(:user) }
  let(:auth_hash) do
    {
      'uid'      => '12345',
      'provider' => 'google_oauth2',
      'info'     => {
        'first_name' => 'Sep',
        'last_name'  => 'Behmanesh',
        'email'      => 'Sep@example.com'
      }
    }
  end

  before do
    request.env['omniauth.auth'] = auth_hash
  end

  describe 'GET #google_oauth2' do
    context 'when the user does not exist' do
      it 'creates a new user and logs them in' do
        expect do
          get :google_oauth2
        end.to change(User, :count).by(1)

        expect(session[:current_user_id]).to eq(User.last.id)
        expect(response).to redirect_to(root_url)
      end
    end
  end

RSpec.describe User, type: :model do
  describe '#name' do
    it 'returns the full name of the user' do
      user = described_class.create!(first_name: 'Sep', last_name: 'Behmanesh', uid: '123', provider: 'google_oauth2')
      expect(user.name).to eq 'Sep Behmanesh'
    end
  end

  describe '#auth_provider' do
    it "returns 'Google' when provider is google_oauth2" do
      user = described_class.create!(first_name: 'Sep', last_name: 'Behmanesh', uid: '123', provider: 'google_oauth2')
      expect(user.auth_provider).to eq 'Google'
    end

    it "returns 'Github' when provider is github" do
      user = described_class.create!(first_name: 'Sep', last_name: 'Behmanesh', uid: '123', provider: 'github')
      expect(user.auth_provider).to eq 'Github'
    end
  end

  describe '.find_google_user' do
    it 'returns a user with a given uid and google_oauth2 provider' do
      user = described_class.create!(first_name: 'Sep', last_name: 'Behmanesh', uid: '123', provider: 'google_oauth2')
      expect(described_class.find_google_user('123')).to eq user
    end
  end

  describe '.find_github_user' do
    it 'returns a user with a given uid and github provider' do
      user = described_class.create!(first_name: 'Sep', last_name: 'Behmanesh', uid: '123', provider: 'github')
      expect(described_class.find_github_user('123')).to eq user
    end
  end
end

# Tests for NewsItem:
RSpec.describe NewsItem, type: :model do
  let(:representative) do
    Representative.create!(
      name:      'Bowen Fan',
      title:     'Representative',
      party:     'Democrat',
      address:   '2546 Warring St, Berkeley, CA, 92081',
      photo_url: 'https://t4.ftcdn.net/jpg/01/43/42/83/360_F_143428338_gcxw3Jcd0tJpkvvb53pfEztwtU9sxsgT.jpg'
    )
  end

  let(:news_item) do
    NewsItem.create!(
      title:          'Sample News',
      description:    'This is a sample news content.',
      representative: representative,
      link:           'www.google.com'
    )
  end

  # context 'associations' do
  #   it 'belongs to a representative' do
  #     expect(news_item.representative).to eq(representative)
  #   end

  #   it 'has many ratings' do
  #     3.times do
  #       news_item.ratings.create(score: 5)
  #     end
  #     expect(news_item.ratings.count).to eq(3)
  #   end
  # end

  # context 'dependent destroy' do
  #   it 'deletes related ratings when deleted' do
  #     news_item.ratings.create(score: 5)
  #     expect { news_item.destroy }.to change { Rating.count }.by(-1)
  #   end
  # end

  describe '.find_for' do
      # it 'finds news items for a representative' do
      #   result = NewsItem.find_for(representative)
      #   expect(result.representative).to eq(representative)
      # end

    it 'returns nil when no news items found for a representative' do
      result = NewsItem.find_for(-1)
      expect(result).to be_nil
    end
  end

RSpec.describe ApplicationHelper, type: :helper do
  describe '.state_ids_by_name' do
    context 'when there are no states' do
      it 'returns an empty hash' do
        expect(described_class.state_ids_by_name).to eq({})
      end
    end
  end

  describe '.state_symbols_by_name' do
    context 'when there are no states' do
      it 'returns an empty hash' do
        expect(described_class.state_symbols_by_name).to eq({})
      end
    end
  end
end

RSpec.describe SearchController, type: :controller do
  describe '#search' do
    let(:address) { '123 Main St, Springfield' }
    let(:service) { instance_double(Google::Apis::CivicinfoV2::CivicInfoService) }
    let(:result) { double('Result from Google API') }

    before do
      allow(Google::Apis::CivicinfoV2::CivicInfoService).to receive(:new).and_return(service)
      allow(service).to receive(:key=)
      allow(service).to receive(:representative_info_by_address).and_return(result)
    end

    context 'when address is present' do
      context 'and API call is successful' do
        it 'fetches representative info and renders the search view' do
          expect(Representative).to receive(:civic_api_to_representative_params).with(result).and_return([])
          get :search, params: { address: address }
          expect(response).to render_template('representatives/search')
        end
      end
    end
  end
end

RSpec.describe LoginController, type: :controller do
  let(:auth_hash) do
    {
      'uid'      => '12345',
      'provider' => 'google_oauth2',
      'info'     => {
        'first_name' => 'John',
        'last_name'  => 'Doe',
        'email'      => 'john@example.com'
      }
    }
  end
  let(:user) { User.create(provider: 'google_oauth2', uid: '12345') }

  before do
    request.env['omniauth.auth'] = auth_hash
  end

  describe 'GET #google_oauth2' do
    context 'when the user does not exist' do
      let(:auth_hash) do
        {
          'uid'      => '123456',
          'provider' => 'google_oauth2',
          'info'     => {
            'first_name' => 'John',
            'last_name'  => 'Doe',
            'email'      => 'john@example.com'
          }
        }
      end

      it 'creates a new user and logs them in' do
        expect do
          get :google_oauth2
        end.to change(User, :count).by(1)

        expect(session[:current_user_id]).to eq(User.last.id)
        expect(response).to redirect_to(root_url)
      end
    end

    context 'when omniauth does not provide enough information' do
      let(:auth_hash) do
        {
          'uid'      => '123456',
          'provider' => 'google_oauth2',
          'info'     => {}
        }
      end

      # it 'does not create a new user' do
      #   expect do
      #     get :google_oauth2
      #   end.not_to change(User, :count)

      #   expect(session[:current_user_id]).to be_nil
      #   expect(response).to redirect_to(root_url)
      # end
    end

    context 'when the user already exists' do
      it 'logs in the user' do
        user

        expect do
          get :google_oauth2
        end.not_to change(User, :count)

        expect(session[:current_user_id]).to eq(user.id)
        expect(response).to redirect_to(root_url)
      end

  describe 'GET #logout' do
    it 'logs out the user' do
      session[:current_user_id] = user.id

      get :logout

      expect(session[:current_user_id]).to be_nil
      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq('You have successfully logged out.')
    end
  end
end

# last 2 example removed- todo later
# # Tests for SessionController:
#
RSpec.describe SessionController, type: :controller do
  let(:user) do
    User.create!(
      first_name: 'Bowen',
      last_name:  'Fan'
    )
  end

  describe 'Before action :require_login!' do
    context 'when a user is already logged in' do
      before do
        session[:current_user_id] = user.id
      end

      # it "sets @current_user" do
      #   get :index
      #   expect(assigns(:current_user)).to eq(user)
      # end
    end

  end
end
#
# Tests for MyEventsController:
# why fails??????
# (id: integer, name: string, description: text, county_id: integer, start_time: datetime, end_time: datetime, created_at: datetime, updated_at: datetime)

RSpec.describe MyEventsController, type: :controller do
  let(:valid_attributes) do
    { id: 1, name: 'event 1', description: 'this is event', county_id: 2, start_time: '2023-10-10 11:00:00',
   end_time: '2023-11-11 12:00:00', created_at: '2023-10-10 11:00:00', updated_at: '2023-10-10 09:00:00' }
  end
  let(:invalid_attributes) do
    { id: 1, name: nil, description: 'this is event', county_id: 2, start_time: '2023-10-10 11:00:00',
   end_time: '2023-11-11 12:00:00', created_at: '2023-10-10 11:00:00', updated_at: '2023-10-10 09:00:00' }
  end
  let(:event1) { Event.create! valid_attributes }

  describe '#new' do
    it 'initializes a new event' do
      get :new
      expect(assigns(:event)).to be_a_new(Event)
    end
  end

  describe 'GET #edit' do
  
  end

  

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) { { name: 'Updated Event' } }

    end

    context 'with invalid params' do
    
    end
  end

  describe 'DELETE #destroy' do
  
  end
end

# Tests for AjaxController:

RSpec.describe AjaxController, type: :controller do
  let(:state) { create(:state) }
  let(:counties) { create_list(:county, 3, state: state) }

  describe 'GET #counties' do
  
  end
end

RSpec.describe MyNewsItemsController, type: :controller do
  describe '#new' do
    # it 'initializes a new news item' do
    #   get :new
    #   expect(assigns(:news_item)).to be_a_new(NewsItem)
    # end
  end

  describe '#edit' do
    let(:news_item) { create(:news_item) }


  end

  describe '#create' do
    context 'with valid parameters' do
      let(:valid_params) { attributes_for(:news_item) }

    end

    context 'with invalid parameters' do
      let(:invalid_params) { { title: '' } } # Assuming title can't be empty, adjust accordingly
    end

  describe '#update' do
    let(:news_item) { create(:news_item) }
    let(:new_title) { 'Updated Title' }

    context 'with valid parameters' do

    end

    context 'with invalid parameters' do
      let(:invalid_title) { '' }
    end
  end

  describe '#destroy' do
    let!(:news_item) { create(:news_item) }
  end
end
