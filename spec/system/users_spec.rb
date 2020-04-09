# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :system do
  let(:user) { create(:user) }
  before do
    driven_by :selenium_chrome_headless
  end

  context 'when valid email and password is filled in' do
    it ' is successful to log in ' do
      visit new_user_session_path
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: user.password
      click_button 'Log in'
      expect(page).to have_content 'ログインしました'
    end
  end

  context 'when invalid email and password is filled in' do
    it ' fails to log in ' do
      visit new_user_session_path
      fill_in 'メールアドレス', with: ''
      fill_in 'パスワード', with: ''
      click_button 'Log in'
      expect(page).to have_content 'メールアドレスまたはパスワードが違います。'
    end
  end
end
