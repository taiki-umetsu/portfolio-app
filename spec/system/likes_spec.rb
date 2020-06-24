# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Likes', type: :system do
  let!(:me) { create(:user) }
  let!(:others) { create(:user) }
  let!(:avatar) { create(:avatar, user: others, public: true) }
  describe 'sign in user' do
    describe 'create like', js: true do
      before do
        sign_in me
        visit user_path(others)
        sleep 0.5
      end
      it 'confirms the number of likes counter', retry: 5 do
        within(:css, '.heart-counter') do
          expect(page).to have_content 0
        end
      end
      it { expect(page).to have_css '#heart' }
      context 'click like button' do
        it 'changes the number of likes counter', retry: 5 do
          find('#heart').click
          sleep 0.5
          within(:css, '.heart-counter') do
            expect(page).to have_content 1
          end
        end
      end
    end
    describe 'destroy likes', js: true do
      let!(:my_like) { create(:like, avatar_id: avatar.id, user_id: me.id) }
      before do
        sign_in me
        visit user_path(others)
        sleep 0.5
      end
      it 'confirms the number of likes counter', retry: 5 do
        within(:css, '.heart-counter') do
          expect(page).to have_content 1
        end
      end
      context 'try to destroy my like' do
        it 'decreases the number of likes counter', retry: 5 do
          find('#heart').click
          sleep 0.5
          within(:css, '.heart-counter') do
            expect(page).to have_content 0
          end
        end
      end
    end
    describe 'likers page' do
      let!(:someone) { create(:user) }
      let!(:liker_1) { create(:like, user: me, avatar: avatar) }
      let!(:liker_2) { create(:like, user: someone, avatar: avatar) }
      before do
        sign_in me
        visit user_path(others)
        sleep 0.5
        find('.heart-counter').click
        sleep 0.5
      end
      it 'goes likers page', retry: 5 do
        expect(page).to have_content 'いいねしたアカウント'
        expect(page).to have_css '.users-wrapper'
      end
      it 'goes back to user page', retry: 5 do
        find('#page-back').click
        expect(page).to have_content '公開アバター'
      end
      it 'is likers names on the page', retry: 5 do
        expect(page).to have_content me.name
        expect(page).to have_content someone.name
      end
      it 'goes to liker page', retry: 5 do
        click_on someone.name
        expect(page).to have_content someone.name
        expect(page).to have_content '公開アバター'
      end
    end
  end

  describe 'not sign in user' do
    it 'redirects login page', retry: 5 do
      visit likers_avatar_path(others)
      expect(page).to have_content 'ログイン'
    end
  end
end
