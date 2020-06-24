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
    it 'deletes avatar and files in S3 as well', vcr: true, retry: 5 do
      visit user_path(me)
      sleep 0.5
      expect(page).to have_content me.name
      find('.destroy-avatar').click
      sleep 0.5
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
      context 'switch to public' do
        let!(:avatar) { create(:avatar, user: me) }
        before do
          visit user_path(me)
          sleep 0.5
          find('.locked-icon').click
          visit current_path
          sleep 0.5
        end
        it 'has icon expresses public', retry: 5 do
          within(:css, ".avatar#{avatar.id}") do
            expect(page).to_not have_css '.locked-icon'
            expect(page).to have_css '.unlocked-icon'
          end
        end
      end
      context 'switch to private' do
        let!(:avatar) { create(:avatar, user: me, public: true) }
        before do
          visit user_path(me)
          sleep 0.5
          find('.unlocked-icon').click
          visit current_path
          sleep 0.5
        end
        it { expect(page).to have_content me.name }
        it 'has icon expresses private', retry: 5, retry_wait: 10, exponential_backoff: true do
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

  describe 'message function', js: true do
    let!(:me) { create(:user) }
    let!(:others) { create(:user) }
    let!(:others_avatar) { create(:avatar, user: others, public: true) }
    let!(:my_avatar) { create(:avatar, user: me) }
    before do
      sign_in me
    end
    context 'at my page' do
      before do
        visit user_path(me)
        sleep 0.5
        find(".avatar#{my_avatar.id}").find('.message-board-icon').click
        sleep 0.5
      end
      it 'shows field', retry: 5, retry_wait: 5, exponential_backoff: true do
        expect(page).to have_content 'カオリアル'
        expect(page).to have_css '.upload-field'
      end
      it 'removes field', retry: 5, retry_wait: 5, exponential_backoff: true do
        find('.fa-times-circle').click
        sleep 0.5
        expect(page).to_not have_css '.upload-field'
      end
      it 'can not send when click update button with no message', retry: 5, retry_wait: 5, exponential_backoff: true do
        find('.upload-field').find('.btn').click
        expect(page).to have_css '.alert-danger'
      end
      it 'shows flash when click update button with no message', retry: 5, retry_wait: 5, exponential_backoff: true do
        fill_in 'メッセージボードに書き込む(最大40文字)', with: 'hello world'
        find('.upload-field').find('.btn').click
        sleep 0.5
        expect(page).to_not have_css '.upload-field'
        expect(page).to have_selector('.alert-success', text: 'メッセージボードを更新しました')
      end
    end
    context 'at others page' do
      before do
        visit user_path(others)
      end
      it { expect(page).to have_css ".avatar#{others_avatar.id}" }
      it { expect(page).to_not have_css '.message-board-icon' }
    end
    context 'fill over 40 characters', retry: 5 do
      before do
        visit user_path(me)
        sleep 0.5
        find(".avatar#{my_avatar.id}").find('.message-board-icon').click
        sleep 0.5
        fill_in 'メッセージボードに書き込む(最大40文字)', with: 'a' * 41
      end
      it { expect(find('#content-form').value).to match 'a' * 40 }
    end
  end
end
