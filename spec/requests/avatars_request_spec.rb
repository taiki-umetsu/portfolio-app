# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Avatars', type: :request do
  describe 'GET /new' do
    it 'returns http success' do
      get '/avatars/new'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /show' do
    it 'returns http success' do
      get '/avatars/show'
      expect(response).to have_http_status(:success)
    end
  end
end
