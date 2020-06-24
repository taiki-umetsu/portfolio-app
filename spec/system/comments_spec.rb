# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Comments', type: :system do
  let!(:me) { create(:user) }
  let!(:others) { create(:user) }
  let!(:avatar) { create(:avatar, user: others, public: true) }
  let!(:my_comment) { create(:comment, avatar: avatar, user: me, content: 'my comment') }
  let!(:others_comment) { create(:comment, avatar: avatar, user: others, content: 'others comment') }
  describe 'create comment', js: true do
    before do
      sign_in me
      visit user_path(others)
      sleep 1
      find('#avatar-comment').click
      sleep 1
    end
    it { expect(page).to have_css '.upload-field' }
    it 'fill something in comment form', retry: 5 do
      fill_in "#{avatar.user.name}さんのアバターへコメント(最大40文字)", with: 'LGTM'
      click_on 'コメント'
      expect(page).to have_content 'コメントしました！'
    end
    it 'fill nothing in comment form', retry: 5 do
      fill_in "#{avatar.user.name}さんのアバターへコメント(最大40文字)", with: ''
      click_on 'コメント'
      expect(page).to have_content 'フォームに入力してください'
    end
    it 'removes field', retry: 5 do
      find('.fa-times-circle').click
      sleep 0.5
      expect(page).to_not have_css '.upload-field'
    end
  end

  describe 'comments page' do
    before do
      sign_in me
      visit user_path(others)
      sleep 0.5
      find('.comment-counter').click
      sleep 0.5
    end
    it 'goes comments page', retry: 5 do
      expect(page).to have_content 'コメント一覧'
      expect(page).to have_css '.users-wrapper'
    end
    it 'goes back to user page', retry: 5 do
      find('#page-back').click
      expect(page).to have_content '公開アバター'
    end
    it 'is comments on the page', retry: 5 do
      expect(page).to have_content my_comment.content
      expect(page).to have_content others_comment.content
    end
    it 'goes to commented user page', retry: 5 do
      click_on me.name
      expect(page).to have_content me.name
      expect(page).to have_content '公開アバター'
    end

    describe 'destroy comment', js: true do
      it 'destroys my comment', retry: 5 do
        # confirmation form will be appeared
        accept_confirm do
          find(".comment#{my_comment.id}").find('.fa-trash-alt').click
        end
        expect(page).to_not have_content 'my comment'
      end

      context 'try to destroy others comment' do
        it 'exists link to delete comment at my comment part', retry: 5 do
          within(:css, ".comment#{my_comment.id}") do
            expect(page).to have_css '.fa-trash-alt'
          end
        end
        it 'does not exist link to delete comment at others comment part', retry: 5 do
          within(:css, ".comment#{others_comment.id}") do
            expect(page).to_not have_css '.fa-trash-alt'
          end
        end
      end
    end
  end
end
