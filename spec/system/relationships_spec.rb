# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Relationships', type: :system do
  let!(:me) { create(:user) }
  let!(:others) { create(:user) }
  let!(:someone) { create(:user) }
  describe 'sign in user' do
    before do
      sign_in me
    end
    describe 'follow and unfollw' do
      let!(:follow_others) { create(:relationship, follower: me, followed: others) }
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
    describe 'followers page' do
      let!(:follower_1) { create(:relationship, follower: others, followed: me) }
      let!(:follower_2) { create(:relationship, follower: someone, followed: me) }
      before do
        visit user_path(me)
        click_on 'フォロワー'
      end
      it 'goes followers page' do
        expect(page).to have_content 'フォロワー'
        expect(page).to have_css '.users-wrapper'
      end
      it 'goes back to user page' do
        find('#page-back').click
        expect(page).to have_content me.name
      end
      it 'is followers names on the page' do
        expect(page).to have_content others.name
        expect(page).to have_content someone.name
      end
      it 'goes to follower user page' do
        click_on others.name
        expect(page).to have_content others.name
      end
    end
    describe 'following page' do
      let!(:following_1) { create(:relationship, follower: me, followed: others) }
      let!(:following_2) { create(:relationship, follower: me, followed: someone) }
      before do
        visit user_path(me)
        click_on 'フォロー中'
      end
      it 'goes following page' do
        expect(page).to have_content 'フォロー中'
        expect(page).to have_css '.users-wrapper'
      end
      it 'goes back to user page' do
        find('#page-back').click
        expect(page).to have_content '公開アバター'
      end
      it 'is following users names on the page' do
        expect(page).to have_content others.name
        expect(page).to have_content someone.name
      end
      it 'goes to following user page' do
        click_on others.name
        expect(page).to have_content others.name
      end
    end
  end

  describe 'not sign in user' do
    it 'redirects login page' do
      visit following_user_path(others)
      expect(page).to have_content 'ログイン'
    end
    it 'redirects login page' do
      visit followers_user_path(others)
      expect(page).to have_content 'ログイン'
    end
  end
end
