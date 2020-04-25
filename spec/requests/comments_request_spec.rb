# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Comments', type: :request do
  describe 'POST #create' do
    let!(:user)   { create(:user) }
    let!(:avatar) { create(:avatar) }
    context 'as a sign in user' do
      before do
        sign_in user
        post comments_path, params: { comment: { avatar_id: avatar.id, content: 'LGTM' } }
      end
      it { expect(response).to redirect_to root_url }
      it { expect(flash[:success]).to be_truthy }
    end
    context 'as a not sign in user' do
      before do
        post comments_path, params: { avatar_id: avatar.id, content: 'LGTM' }
      end
      it { expect(response).to redirect_to new_user_session_url }
      it { expect(flash[:alert]).to be_truthy }
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
        delete comment_path(my_comment)
      end
      it { expect(response).to redirect_to root_url }
      it { expect(flash[:success]).to be_truthy }
    end
    context 'as a not sign in user' do
      before do
        delete comment_path(my_comment)
      end
      it { expect(response).to redirect_to new_user_session_url }
      it { expect(flash[:alert]).to be_truthy }
    end
    context 'try to destroy others comment' do
      before do
        sign_in user
        delete comment_path(others_comment)
      end
      it { expect(response).to redirect_to root_url }
      it { expect(flash[:danger]).to be_truthy }
    end
  end
end
