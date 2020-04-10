# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :system do
  let(:user) { create(:user) }
  before do
    driven_by :selenium_chrome_headless
  end

  describe 'Log in' do
    context 'when valid email and password is filled in' do
      before do
        visit new_user_session_path
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: user.password
        click_on 'LOG IN'
      end
      it ' is successful to log in ' do
        expect(page).to have_content 'ログインしました'
      end
      it " doesn't have SIGNUP link after log in " do
        expect(page).to_not have_link 'SIGNUP'
      end
      it " doesn't have LOGIN link after log in " do
        expect(page).to_not have_link 'LOGIN'
      end
      it ' is successful to log out ' do
        click_on 'LOGOUT'
        expect(page).to have_content 'ログアウトしました'
      end
    end

    context 'when invalid email and password is filled in' do
      it ' fails to log in ' do
        visit new_user_session_path
        fill_in 'メールアドレス', with: ''
        fill_in 'パスワード', with: ''
        click_on 'LOG IN'
        expect(page).to have_content 'メールアドレスまたはパスワードが違います。'
      end
    end
  end

  describe 'Sign up form' do
    before do
      visit new_user_registration_path
    end
    context 'when valid email and password is filled in' do
      it ' is successful to log in ' do
        fill_in 'メールアドレス', with: 'example@example.com'
        fill_in 'パスワード', with: 'password'
        fill_in '確認用パスワード', with: 'password'
        click_on 'SIGN UP'
        expect(page).to have_content 'アカウント登録が完了しました'
      end
    end
    context 'when invalid email and password is filled in' do
      it ' fails to log in ' do
        fill_in 'メールアドレス', with: ''
        fill_in 'パスワード', with: ''
        fill_in '確認用パスワード', with: ''
        click_on 'SIGN UP'
        expect(page).to have_content 'メールアドレス を記入してください'
        expect(page).to have_content 'パスワード を記入してください'
      end
    end
  end
end
