# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :system do
  let!(:me) { create(:user) }
  describe 'Log in', js: true do
    context 'when valid email and password is filled in' do
      before do
        visit new_user_session_path
        fill_in 'メールアドレス', with: me.email
        fill_in 'パスワード', with: me.password
        click_on 'ログイン'
      end
      it ' is successful to log in ' do
        expect(page).to have_content 'ログインしました'
      end
      describe 'links for logged in user at navigation window' do
        before do
          sleep 1
          find('#header-icon').click
        end
        it { expect(page).to_not have_link '新規作成' }
        it { expect(page).to_not have_link 'ログイン' }
        it { expect(page).to have_link 'マイページ' }
        it { expect(page).to have_link '設定' }
        it ' is successful to log out ' do
          click_on 'ログアウト'
          expect(page).to have_content 'ログアウトしました'
        end
      end
    end

    context 'when invalid email and password is filled in' do
      before do
        visit new_user_session_path
        fill_in 'メールアドレス', with: ''
        fill_in 'パスワード', with: ''
        click_on 'ログイン'
      end
      it { expect(page).to_not have_content 'ログインしました' }
      it { expect(page).to have_content 'メールアドレスを入力して下さい。' }
      it { expect(page).to have_content 'パスワードを入力して下さい。' }
    end
  end

  describe 'Sign up', js: true do
    before do
      visit new_user_registration_path
    end

    context 'when valid email and password is filled in' do
      before do
        fill_in '名前', with: 'example'
        fill_in 'メールアドレス', with: 'example@example.com'
        fill_in 'パスワード（6文字以上）', with: 'password'
        fill_in 'パスワード（確認）', with: 'password'
        click_on '作成'
      end
      it { expect(page).to have_content 'アカウント登録が完了しました' }
    end

    context 'when invalid email and password is filled in' do
      before do
        fill_in '名前', with: ''
        fill_in 'メールアドレス', with: ''
        fill_in 'パスワード（6文字以上）', with: ''
        fill_in 'パスワード（確認）', with: ''
        click_on '作成'
      end
      it { expect(page).to have_content '名前を入力して下さい。' }
      it { expect(page).to have_content 'メールアドレスを入力して下さい。' }
      it { expect(page).to have_content 'パスワードを入力して下さい。' }
      it { expect(page).to have_content '確認用パスワードを入力して下さい。' }
    end
  end

  describe 'Account edit', js: true do
    before do
      sign_in me
      visit edit_user_registration_path
      sleep 0.5
    end
    it { expect(page).to have_css 'h4', text: '登録内容の設定' }
    it { expect(page).to have_css '#trim' }
    it { expect(page).to_not have_css '.upload-field' }
    it { expect(page).to_not have_css '.crop-field' }
    describe 'edit icon image field' do
      before do
        find('#trim').find('.icon').click
        sleep 0.5
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
      it 'uploads image to crop field' do
        page.execute_script("$('input').css('margin-left', '')")
        page.execute_script("$('input').attr('name', 'image')")
        attach_file 'image', Rails.root.join('spec/fixtures/texture_face.png')
        find('.upload-field').find('.btn').click
        expect(page).to_not have_css '.upload-field'
      end
    end
    describe 'edit account informations' do
      context 'when valid informations is filled in' do
        before do
          fill_in '名前', with: 'changed_name'
          fill_in 'メールアドレス', with: 'changed_email@example.com'
          fill_in 'パスワード', with: me.password
          click_on '更新'
        end
        it { expect(page).to have_content 'アカウント情報を変更しました。' }
      end
      context 'when empty informations is filled in' do
        before do
          fill_in '名前', with: ''
          fill_in 'メールアドレス', with: ''
          fill_in 'パスワード', with: ''
          click_on '更新'
        end
        it { expect(page).to have_content '名前を入力して下さい。' }
        it { expect(page).to have_content 'メールアドレスを入力して下さい。' }
        it { expect(page).to have_content 'パスワードを入力して下さい。' }
      end
      context 'when invalid password is filled in' do
        before do
          fill_in '名前', with: me.name
          fill_in 'メールアドレス', with: me.email
          fill_in 'パスワード', with: 'foo'
          click_on '更新'
        end
        it { expect(page).to have_content 'パスワードが違います。' }
      end
      context 'when invalid email is filled in' do
        before do
          fill_in '名前', with: me.name
          fill_in 'メールアドレス', with: 'invalid_email'
          fill_in 'パスワード', with: me.password
          click_on '更新'
        end
        it { expect(page).to have_content 'Eメールの形式で入力して下さい。' }
      end
      describe 'try to change password' do
        before do
          fill_in '名前', with: me.name
          fill_in 'メールアドレス', with: me.email
          fill_in 'パスワード', with: me.password
          click_on 'パスワード変更'
        end
        context 'when valid new password is filled in' do
          before do
            fill_in '新パスワード (6文字以上)', with: 'foobar'
            fill_in '新パスワード (確認)', with: 'foobar'
            click_on '更新'
          end
          it { expect(page).to have_content 'アカウント情報を変更しました。' }
        end
        context 'when invalid new password is filled in' do
          before do
            fill_in '新パスワード (6文字以上)', with: 'foo'
            fill_in '新パスワード (確認)', with: 'foo'
            click_on '更新'
          end
          it { expect(page).to have_content '6文字以上必要です。' }
        end
        context 'when invalid confirmation password is filled in' do
          before do
            fill_in '新パスワード (6文字以上)', with: 'foobar'
            fill_in '新パスワード (確認)', with: 'foo'
            click_on '更新'
          end
          it { expect(page).to have_content '新パスワードと一致しません。' }
        end
      end
    end
  end
end
