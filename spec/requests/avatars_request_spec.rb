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
  describe 'AWS S3' do
    it 'uploads and deletes image', vcr: true do
      VCR.use_cassette('upload_to_s3', preserve_exact_body_bytes: true) do
        Avatar::Ready3dFiles.new(1, Rails.root.join('spec/fixtures/texture_face.png'))
        @res = Net::HTTP.get_response(URI(ENV['AWS_S3_TEST_URI']))
      end
      expect(@res.code).to eq '200'

      VCR.use_cassette('delete_to_s3') do
        avatar.destroy_s3_file
        @res = Net::HTTP.get_response(URI(ENV['AWS_S3_TEST_URI']))
      end
      expect(@res.code).to eq '403'
    end
  end
  describe 'Amazon Rekognition' do
    it 'detects face in a image', vcr: true do
      VCR.use_cassette('request_to_amazon_rekognition', preserve_exact_body_bytes: true) do
        image_path = Rails.root.join('spec/fixtures/texture_face.png')
        @detect = Avatar::DetectFace.new(File.open(image_path, 'rb').read)
      end
      expect(@detect.response.successful?).to eq true
    end
  end
end
