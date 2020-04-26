# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Likes', type: :request do
  describe 'POST #create' do
    let!(:user)   { create(:user) }
    let!(:avatar) { create(:avatar) }
    context 'as a sign in user' do
      before do
        sign_in user
        post likes_path, params: { like: { avatar_id: avatar.id } }
      end
      it { expect(response).to redirect_to root_url }
    end
    context 'as a not sign in user' do
      before do
        post likes_path, params: { avatar_id: avatar.id }
      end
      it { expect(response).to redirect_to new_user_session_url }
      it { expect(flash[:alert]).to be_truthy }
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
        delete like_path(my_like)
      end
      it { expect(response).to redirect_to root_url }
    end
    context 'as a not sign in user' do
      before do
        delete like_path(my_like)
      end
      it { expect(response).to redirect_to new_user_session_url }
      it { expect(flash[:alert]).to be_truthy }
    end
    context 'try to destroy others like' do
      before do
        sign_in user
        delete like_path(others_like)
      end
      it { expect(response).to redirect_to root_url }
      it { expect(flash[:danger]).to be_truthy }
    end
  end
end
