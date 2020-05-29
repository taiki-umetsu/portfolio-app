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
    it 'no avatar at the page' do
      within(:css, '#avatar-field') do
        expect(page).to_not have_css '.wrapper'
      end
    end
    it 'create avatar by using Amazon Rekognition and S3',
       vcr: { cassette_name: 'create_avatar', preserve_exact_body_bytes: true } do
      page.execute_script("$('input').css('margin-left', '')")
      page.execute_script("$('input').attr('name', 'image')")
      attach_file 'image', Rails.root.join('spec/fixtures/texture_face.png')
      find('.upload-field').find('.btn').click
      within(:css, '#avatar-field') do
        expect(page).to have_css '.wrapper'
      end
    end
  end

  describe 'delete avatar', js: true do
    let!(:me) { create(:user) }
    let!(:others) { create(:user) }
    let!(:avatar) { create(:avatar, user: me) }
    let!(:others_avatar) { create(:avatar, user: others, public: true) }
    before do
      sign_in me
    end
    it 'deletes avatar and files in S3 as well', vcr: true do
      visit user_path(me)
      expect(page).to have_content me.name
      find('.destroy-avatar').click
      VCR.use_cassette('delete_avatar') do
        page.driver.browser.switch_to.alert.accept
      end
      expect(page).to have_content 'アバターを削除しました'
    end
    it "doesn't show the delete link in another user's page" do
      visit user_path(others)
      expect(page).to have_content others.name
      expect(page).to have_css ".avatar#{others_avatar.id}"
      expect(page).to_not have_css '.destroy-avatar'
    end
  end

  describe 'public function', js: true do
    let!(:me) { create(:user) }
    let!(:others) { create(:user) }
    before do
      sign_in me
    end
    describe 'the icon is shown to only avatar owner' do
      context 'avatar owner' do
        let!(:avatar) { create(:avatar, user: me) }
        it 'shows icon' do
          visit user_path(me)
          within(:css, ".avatar#{avatar.id}") do
            expect(page).to have_css '.locked-icon'
          end
        end
      end
      context 'not avatar owner' do
        let!(:avatar) { create(:avatar, user: others, public: true) }
        it 'does not show icon' do
          visit user_path(others)
          within(:css, ".avatar#{avatar.id}") do
            expect(page).to_not have_css '.locked-icon'
          end
        end
      end
    end
    describe 'click the icon to swich public/private mode' do
      let!(:avatar) { create(:avatar, user: me) }
      before do
        visit user_path(me)
      end
      it { expect(page).to_not have_css '.unlocked-icon' }
      it { expect(page).to have_css '.locked-icon' }
      context 'switch to public' do
        before do
          find('.locked-icon').click
          visit current_path
        end
        it { expect(page).to have_content me.name }
        it 'has icon expresses public' do
          within(:css, ".avatar#{avatar.id}") do
            expect(page).to_not have_css '.locked-icon'
            expect(page).to have_css '.unlocked-icon'
          end
        end
      end
      context 'switch to private' do
        before do
          find('.locked-icon').click
          sleep 1
          find('.unlocked-icon').click
          visit current_path
        end
        it { expect(page).to have_content me.name }
        it 'has icon expresses private' do
          within(:css, ".avatar#{avatar.id}") do
            expect(page).to_not have_css '.unlocked-icon'
            expect(page).to have_css '.locked-icon'
          end
        end
      end
    end
    describe 'how  public/private mode avatar has seen' do
      context 'private mode' do
        let!(:avatar) { create(:avatar, user: others, public: false) }
        before do
          visit user_path(others)
        end
        it { expect(page).to_not have_css ".avatar#{avatar.id}" }
      end
      context 'public mode' do
        let!(:avatar) { create(:avatar, user: others, public: true) }
        before do
          visit user_path(others)
        end
        it { expect(page).to have_css ".avatar#{avatar.id}" }
      end
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
