# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Likes', type: :request do
  describe 'POST #create' do
    let!(:user)   { create(:user) }
    let!(:avatar) { create(:avatar, user: user) }
    context 'as a sign in user' do
      before do
        sign_in user
        post api_v1_likes_path, params: { avatar_id: avatar.id }
      end
      it { expect(response).to have_http_status(:success) }
    end
    context 'as a not sign in user' do
      before do
        post api_v1_likes_path, params: { avatar_id: avatar.id }
      end
      it { expect(response.body).to eq '{"error":"アカウント登録もしくはログインしてください。"}' }
    end
  end

  describe 'DELETE #destroy' do
    let!(:user) { create(:user) }
    let!(:others) { create(:user) }
    let!(:someone) { create(:user) }
    let!(:someone_avatar) { create(:avatar, user_id: someone.id) }
    let!(:my_like) { create(:like, user_id: user.id, avatar_id: someone_avatar.id) }
    let!(:others_like) { create(:like, user_id: others.id, avatar_id: someone_avatar.id) }

    context 'as a sign in user' do
      before do
        sign_in user
        delete api_v1_like_path(my_like)
      end
      it { expect(response).to have_http_status(:success) }
    end
    context 'as a not sign in user' do
      before do
        delete api_v1_like_path(my_like)
      end
      it { expect(response.body).to eq '{"error":"アカウント登録もしくはログインしてください。"}' }
    end
    context 'try to destroy others like' do
      before do
        sign_in user
        delete api_v1_like_path(others_like)
      end
      it { expect(response.body).to eq 'いいねの削除権限がありません' }
    end
  end
end
