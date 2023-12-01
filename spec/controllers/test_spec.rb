# frozen_string_literal: true

require 'rails_helper'
# Test for representative.rb:

RSpec.describe 'Tests', type: :controller do
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
        existing_rep = described_class.create!(name: 'Existing Rep', ocdid: '123', title: 'Mayor')
        expect { described_class.civic_api_to_representative_params(rep_info) }.not_to change(described_class, :count)
        existing_rep.reload
        expect(existing_rep.slice(:name, :title)).to eq({ name: 'Existing Rep', title: 'Mayor' })
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
          { 'id' => county.id, 'name' => county.name, 'state_id' => county.state_id }
        end
        expect(response.body).to eq(expected_response.to_json)
      end

      it 'returns a 404 response when state symbol is not found' do
        get :counties, params: { state_symbol: 'invalid-symbol' }
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  # Test for MyNewsItemsController

  RSpec.describe MyNewsItemsController, type: :controller do
    describe '#new' do
      it 'initializes a new news item' do
        get :new
        expect(assigns(:news_item)).to be_a_new(NewsItem)
      end
    end

    describe '#edit' do
      let(:news_item) { create(:news_item) }

      it 'fetches the specified news item for editing' do
        get :edit, params: { id: news_item.id }
        expect(assigns(:news_item)).to eq(news_item)
      end
    end

    describe '#create' do
      context 'with valid parameters' do
        let(:valid_params) { attributes_for(:news_item) }

        it 'creates a new news item' do
          expect do
            post :create, params: { news_item: valid_params }
          end.to change(NewsItem, :count).by(1)
        end

        it 'redirects to the created news item page with a success message' do
          post :create, params: { news_item: valid_params }
          expect(response).to redirect_to(representative_news_item_path(assigns(:representative), NewsItem.last))
          expect(flash[:notice]).to eq('News item was successfully created.')
        end
      end

      context 'with invalid parameters' do
        let(:invalid_params) { { title: '' } }

        it 'does not create a news item' do
          expect do
            post :create, params: { news_item: invalid_params }
          end.not_to change(NewsItem, :count)
        end

        it 'renders the edit template with an error message' do
          post :create, params: { news_item: invalid_params }
          expect(response).to render_template(:new)
        end
      end
    end

    describe '#update' do
      let(:news_item) { create(:news_item) }
      let(:new_title) { 'Updated Title' }

      context 'with valid parameters' do
        it 'updates the requested news item' do
          put :update, params: { id: news_item.id, news_item: { title: new_title } }
          expect(news_item.reload.title).to eq(new_title)
        end

        it 'redirects to the news item with a success message' do
          put :update, params: { id: news_item.id, news_item: { title: new_title } }
          expect(response).to redirect_to(representative_news_item_path(assigns(:representative), news_item))
          expect(flash[:notice]).to eq('News item was successfully updated.')
        end
      end

      context 'with invalid parameters' do
        let(:invalid_title) { '' }

        it 'does not update the news item' do
          put :update, params: { id: news_item.id, news_item: { title: invalid_title } }
          expect(news_item.reload.title).not_to eq(invalid_title)
        end

        it 'rerenders the :edit template' do
          put :update, params: { id: news_item.id, news_item: { title: invalid_title } }
          expect(response).to render_template(:edit)
        end
      end
    end

    describe '#destroy' do
      let!(:news_item) { create(:news_item) }

      it 'deletes the requested news item' do
        expect do
          delete :destroy, params: { id: news_item.id }
        end.to change(NewsItem, :count).by(-1)
      end

      it 'redirects to the representative news items list with a success message' do
        delete :destroy, params: { id: news_item.id }
        expect(response).to redirect_to(representative_news_items_path(assigns(:representative)))
        expect(flash[:notice]).to eq('News was successfully destroyed.')
      end
    end
  end

  # Tests for ApplicationController:

  RSpec.describe ApplicationController, type: :controller do
    controller do
      def index
        render plain: 'OKAY'
      end
    end

    describe '#authenticated' do
      context 'when the user is logged in' do
        before do
          session[:current_user_id] = 1 # assuming 1 is a valid user ID
        end

        it 'sets @authenticated to true' do
          get :index
          expect(assigns(:authenticated)).to be(true)
        end
      end

      context 'when the user is not logged in' do
        it 'sets @authenticated to false' do
          get :index
          expect(assigns(:authenticated)).to be(false)
        end
      end
    end
  end
end
