# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Avatars', type: :system do
  let(:user) { create(:user) }
  let(:avatar) { create(:avatar, user: user) }

  describe 'create new avatar', js: true do
    before do
      sign_in user
      visit user_path(user)
      find('.create-avatar').click
    end
    it { expect(page).to have_css '.upload-field' }
    it 'removes field' do
      find('.fa-times-circle').click
      expect(page).to_not have_css '.upload-field'
    end
    it 'shows flash when click update button with no image' do
      find('.upload-field').find('.btn').click
      expect(page).to have_content '画像を選択してください'
    end

    it 'create avatar by using Amazon Rekognition and S3', vcr: true do
      page.execute_script("$('input').css('margin-left', '')")
      page.execute_script("$('input').attr('name', 'image')")
      attach_file 'image', Rails.root.join('spec/fixtures/texture_face.png')
      VCR.use_cassette('create_avatar', preserve_exact_body_bytes: true) do
        find('.upload-field').find('.btn').click
      end
      expect(page).to_not have_css '.upload-field'
    end
  end

  describe 'delete avatar', js: true do
    let!(:me) { create(:user) }
    let!(:others) { create(:user) }
    let!(:avatar) { create(:avatar, user: me) }
    before do
      sign_in me
      visit user_path(me)
      sleep 0.5
    end
    it 'deletes avatar and files in S3 as well', vcr: true do
      find('div[id=avatar-edit]').click
      find('.tab-content').find('.fa-trash-alt').click
      VCR.use_cassette('delete_avatar') do
        page.driver.browser.switch_to.alert.accept
      end
      expect(page).to have_content 'アバターを削除しました'
    end
    it "doesn't show the delete link in another user's page" do
      click_on 'LOGOUT'
      sign_in others
      visit user_path(me)
      expect(page).to_not have_link 'DELETE'
    end
  end

  describe 'public function' do
    let!(:me) { create(:user) }
    let!(:others) { create(:user) }
    before do
      sign_in me
    end
    describe 'check field to activate public function exist' do
      let!(:avatar) { create(:avatar, user: me) }
      before do
        visit user_path(me)
        find('div[id=avatar-edit]').click
      end
      it { expect(page).to have_selector 'div[class=form-check-input]' }
      it { expect(page).to have_unchecked_field('avatar[public]') }
    end
    context 'private mode' do
      let!(:avatar) { create(:avatar, user: others, public: false) }
      before do
        visit user_path(others)
      end
      it { expect(page).to_not have_selector 'iframe' }
    end
    context 'public mode' do
      let!(:avatar) { create(:avatar, user: others, public: true) }
      before do
        visit user_path(others)
      end
      it { expect(page).to have_selector 'iframe' }
    end
  end

  describe 'message function' do
    let!(:me) { create(:user) }
    let!(:others) { create(:user) }
    let!(:others_avatar) { create(:avatar, user: others) }
    let!(:my_avatar) { create(:avatar, user: me) }
    before do
      sign_in me
    end
    context 'at my page' do
      before do
        visit user_path(me)
        fill_in 'avatar[message]', with: 'Hello'
        click_on 'アップデート'
      end
      it { expect(page).to have_content 'アップデートしました' }
    end
    context 'at others page' do
      before do
        visit user_path(others)
      end
      it { expect(page).to_not have_selector 'div[id=avatar-edit]' }
      it { expect(page).to_not have_css '#avatar_message' }
    end
    context 'fill over 40 characters' do
      before do
        visit user_path(me)
        fill_in 'avatar[message]', with: 'a' * 41
        click_on 'アップデート'
      end
      it { expect(page).to have_content 'アップデートできませんでした' }
    end
  end
end
