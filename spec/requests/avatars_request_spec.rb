# frozen_string_literal: true

require 'rails_helper'
RSpec.describe 'Avatars', type: :request do
  let(:user)   { create(:user) }
  let(:avatar) { create(:avatar, user: user) }

  describe 'GET /show' do
    it 'returns http success' do
      get avatar_path(avatar)
      expect(response).to have_http_status(:success)
    end
  end
  describe 'GET /markerless_ar' do
    it 'returns http success' do
      get markerless_ar_avatar_path(avatar)
      expect(response).to have_http_status(:success)
    end
  end
end
