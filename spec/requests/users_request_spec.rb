# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let(:user)   { create(:user) }
  let(:avatar) { create(:avatar, user: user) }
  describe 'GET /index' do
    it 'returns http success' do
      sign_in user
      get users_path
      expect(response).to have_http_status(:success)
    end
    it 'returns http redirect for not signed user' do
      get users_path
      expect(response).to have_http_status(302)
    end
  end

  describe 'GET /show' do
    it 'returns http success' do
      sign_in user
      get user_path(user)
      expect(response).to have_http_status(:success)
    end
    it 'returns http redirect for not signed user' do
      get user_path(user)
      expect(response).to have_http_status(302)
    end
  end
end
