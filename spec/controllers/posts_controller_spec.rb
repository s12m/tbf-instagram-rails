require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  let!(:user) { create(:user) }

  describe 'GET #index' do
    let!(:posts) { create_list(:post, 3, user: user) }
    let!(:other_posts) { create_list(:post, 3, user: create(:user)) }

    context 'when signed in' do
      before do
        sign_in user
      end

      it 'returns http success' do
        get :index
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:index)
        expect(assigns(:posts)).to eq(posts.reverse)
      end
    end

    context 'when not signed in' do
      it 'redirects to sign in url' do
        get :index
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe 'GET #show' do
    let!(:post) { create(:post, user: user) }
    let!(:other_post) { create(:post, user: create(:user)) }

    context 'when signed in' do
      before do
        sign_in user
      end

      it 'returns http success' do
        get :show, params: {id: post.id }
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:show)
        expect(assigns(:post)).to eq(post)
      end

      it 'raises ActiveRecord::RecordNotFound when other user post' do
        expect {
          get :show, params: { id: other_post.id }
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when not signed in' do
      it 'redirects to sign in url' do
        get :show, params: { id: post.id }
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe 'GET #new' do
    context 'when signed in' do
      before do
        sign_in user
      end

      it 'returns http success' do
        get :new
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:new)
        expect(assigns(:post)).to be_new_record
      end
    end

    context 'when not signed in' do
      it 'redirects to sign in url' do
        get :new
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe 'GET #edit' do
    let!(:post) { create(:post, user: user) }
    let!(:other_post) { create(:post, user: create(:user)) }

    context 'when signed in' do
      before do
        sign_in user
      end

      it 'returns http success' do
        get :edit, params: { id: post.id }
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:edit)
        expect(assigns(:post)).to eq(post)
      end

      it 'raises ActiveRecord::RecordNotFound when other user post' do
        expect {
          get :edit, params: { id: other_post.id }
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when not signed in' do
      it 'redirects to sign in url' do
        get :edit, params: { id: post.id }
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe 'POST #create' do
    let!(:post_attributes) { attributes_for(:post) }

    context 'when signed in' do
      before do
        sign_in user
      end

      it 'creates post' do
        post :create, params: { post: post_attributes }
        expect(response).to redirect_to(posts_url)
      end

      it 'does not create post when invalid params' do
        post :create, params: { post: post_attributes.merge(body: '') }
        expect(response).to render_template(:new)
        expect(assigns(:post)).to_not be_persisted
        expect(assigns(:post).errors[:body]).to be_any
      end
    end

    context 'when not signed in' do
      it 'redirects to sign in url' do
        post :create, params: { post: post_attributes }
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe 'PATCH #update' do
    let!(:post) { create(:post, user: user) }
    let!(:other_post) { create(:post, user: create(:user)) }
    let!(:post_attributes) { { body: 'Updated body' } }

    context 'when signed in' do
      before do
        sign_in user
      end

      it 'updates post' do
        patch :update, params: { id: post.id, post: post_attributes }
        expect(response).to redirect_to(posts_url)
        expect(post.reload.body).to eq('Updated body')
      end

      it 'does not update post when invalid params' do
        patch :update, params: { id: post.id, post: { body: '' } }
        expect(response).to render_template(:edit)
        expect(assigns(:post).errors[:body]).to be_any
      end

      it 'raises ActiveRecord::RecordNotFound when other user post' do
        expect {
          patch :update, params: { id: other_post.id, post: post_attributes }
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when not signed in' do
      it 'redirects to sign in url' do
        patch :update, params: { id: post.id, post: post_attributes }
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:post) { create(:post, user: user) }
    let!(:other_post) { create(:post, user: create(:user)) }

    context 'when signed in' do
      before do
        sign_in user
      end

      it 'deletes post' do
        delete :destroy, params: { id: post.id }
        expect(response).to redirect_to(posts_url)
        expect(assigns(:post)).to be_destroyed
      end

      it 'raises ActiveRecord::RecordNotFound when other user post' do
        expect {
          delete :destroy, params: { id: other_post.id }
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when not signed in' do
      it 'redirects to sign in url' do
        delete :destroy, params: { id: post.id }
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end
end
