# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Comments', type: :request do
  describe 'POST #create' do
    let!(:user)   { create(:user) }
    let!(:avatar) { create(:avatar) }
    context 'as a sign in user' do
      before do
        sign_in user
        post api_v1_comments_path, params: { comment: { avatar_id: avatar.id, content: 'LGTM' } }
      end
      it { expect(response).to have_http_status(:success) }
    end
    context 'as a not sign in user' do
      before do
        post api_v1_comments_path, params: { comment: { avatar_id: avatar.id, content: 'LGTM' } }
      end
      it { expect(response.body).to eq '{"error":"アカウント登録もしくはログインしてください。"}' }
    end
  end

  describe 'DELETE #destroy' do
    let!(:user) { create(:user) }
    let!(:others) { create(:user) }
    let!(:my_comment) { create(:comment, user: user) }
    let!(:others_comment) { create(:comment, user: others) }
    context 'as a sign in user' do
      before do
        sign_in user
        delete api_v1_comment_path(my_comment)
      end
      it { expect(response).to have_http_status(:success) }
    end
    context 'as a not sign in user' do
      before do
        delete api_v1_comment_path(my_comment)
      end
      it { expect(response.body).to eq '{"error":"アカウント登録もしくはログインしてください。"}' }
    end
    context 'try to destroy others comment' do
      before do
        sign_in user
        delete api_v1_comment_path(others_comment)
      end
      it { expect(response.body).to eq 'コメントの削除権限がありません' }
    end
  end
end
