require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  describe 'GET #index' do
    let!(:posts) { create_list(:post, 3, user: create(:user)) }

    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:index)
      expect(assigns(:posts)).to eq(posts.reverse)
    end
  end
end
