# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Avatars', type: :system do
  before do
    sign_in user
  end
  let(:user) { create(:user) }
  let(:avatar) { create(:avatar, user: user) }

  describe 'create new avatar' do
    before do
      visit user_path(user)
    end
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
    before do
      create(:avatar, user: user)
      visit user_path(user)
    end
    it 'deletes avatar and files in S3 as well', vcr: true do
      find('.avatars').find('.fa-trash-alt').click
      VCR.use_cassette('delete_avatar') do
        page.driver.browser.switch_to.alert.accept
      end
      expect(page).to have_content 'アバターを削除しました'
    end
    it "doesn't show the delete link in another user's page" do
      click_on 'LOGOUT'
      user2 = create(:user)
      sign_in user2
      visit user_path(user)
      expect(page).to_not have_link 'DELETE'
    end
  end

  describe 'public function' do
    describe 'check field to activate public function exist' do
      before do
        create(:avatar, user: user)
        visit user_path(user)
      end
      it { expect(page).to have_unchecked_field('公開する') }
    end
    context 'private mode' do
      before do
        create(:avatar, user: user, public: false)
        visit root_path
      end
      it { expect(page).to_not have_css '.avatars' }
    end
    context 'public mode' do
      before do
        create(:avatar, user: user, public: true)
        visit root_path
      end
      it { expect(page).to have_css '.avatars' }
    end
  end
end
