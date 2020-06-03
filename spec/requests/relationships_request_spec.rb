# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Relationships', type: :request do
  describe 'POST #create' do
    let!(:me) { create(:user) }
    let!(:others) { create(:user) }
    let!(:someone) { create(:user) }
    let!(:follow_others) { create(:relationship, follower: me, followed: others) }

    describe 'not ajax' do
      context 'as a not sign in user' do
        it 'fails to create' do
          post relationships_path
          expect(response).to redirect_to(new_user_session_path)
        end
        it 'fails to destroy' do
          delete relationship_path(follow_others)
          expect(response).to redirect_to(new_user_session_path)
        end
      end
      context 'as a sign in user' do
        before do
          sign_in me
        end
        it 'successfully create' do
          post relationships_path, params: { followed_id: someone.id }
          expect(response).to redirect_to(user_path(someone))
        end
        it 'successfully destroy' do
          delete relationship_path(follow_others)
          expect(response).to redirect_to(user_path(others))
        end
      end
    end

    describe 'ajax' do
      context 'as a not sign in user' do
        it 'fails to create' do
          post relationships_path, xhr: true
          expect(response).to have_http_status(401)
        end
        it 'fails to destroy' do
          delete relationship_path(follow_others), xhr: true
          expect(response).to have_http_status(401)
        end
      end
      context 'as a sign in user' do
        before do
          sign_in me
        end
        it 'successfully create' do
          post relationships_path, params: { followed_id: someone.id }, xhr: true
          expect(response).to have_http_status(:success)
        end
        it 'successfully destroy' do
          delete relationship_path(follow_others), xhr: true
          expect(response).to have_http_status(:success)
        end
      end
    end
  end
end
