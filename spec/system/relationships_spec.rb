# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Relationships', type: :system do
  let!(:me) { create(:user) }
  let!(:others) { create(:user) }
  let!(:someone) { create(:user) }
  let!(:follow_others) { create(:relationship, follower: me, followed: others) }
  before do
    sign_in me
  end
  it 'successfully follow' do
    visit user_path(someone)
    within(:css, '.follower') do
      expect(page).to have_content 0
    end
    click_on 'フォローする'
    within(:css, '.follower') do
      expect(page).to have_content 1
    end
  end
  it 'successfully unfollow' do
    visit user_path(others)
    within(:css, '.follower') do
      expect(page).to have_content 1
    end
    click_on 'フォロー中'
    within(:css, '.follower') do
      expect(page).to have_content 0
    end
  end
  it 'does not show follow button at my page' do
    visit user_path(me)
    expect(page).to_not have_css '.follow-btn'
  end
end
