# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Avatars', type: :system do
  before do
    driven_by :selenium_chrome_headless
    sign_in user
    visit user_path(user)
  end
  let(:user) { create(:user) }
  let(:avatar) { create(:avatar, user: user) }

  describe 'create new avatar' do
    it { expect(page).to have_button 'CREATE' }
    it 'create avatar by using Amazon Rekognition and S3', vcr: true do
      attach_file 'picture', Rails.root.join('spec/fixtures/texture_face.png')
      VCR.use_cassette('create_avatar', preserve_exact_body_bytes: true) do
        click_button 'CREATE'
      end
      expect(page).to have_content 'アバターを作成しました！'
    end
  end
  describe 'delete avatar' do
    it 'deletes avatar and files in S3 as well', vcr: true do
      attach_file 'picture', Rails.root.join('spec/fixtures/texture_face.png')
      VCR.use_cassette('create_avatar', preserve_exact_body_bytes: true) do
        click_button 'CREATE'
      end
      click_on 'DELETE'
      VCR.use_cassette('delete_avatar') do
        page.driver.browser.switch_to.alert.accept
      end
      expect(page).to have_content 'アバターを削除しました'
    end
  end
end
