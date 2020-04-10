# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Avatars', type: :system do
  before do
    driven_by :selenium_chrome_headless
  end
  let(:user) { create(:user) }
  let(:avatar) { create(:avatar, user: user) }

  it 'shows the page creates new avatar' do
    visit new_avatar_path
    expect(page).to have_button 'create'
  end
end
