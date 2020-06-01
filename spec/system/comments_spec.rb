# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Comments', type: :system do
  describe 'create comment', js: true do
    let!(:me) { create(:user) }
    let!(:others) { create(:user) }
    let!(:avatar) { create(:avatar, user: others, public: true) }
    before do
      sign_in me
      visit user_path(others)
      sleep 0.5
      find('#avatar-comment').click
      sleep 0.5
    end
    it { expect(page).to have_css '.upload-field' }
    it 'fill something in comment form' do
      fill_in "#{avatar.user.name}さんのアバターへコメント(最大40文字)", with: 'LGTM'
      click_on 'コメント'
      expect(page).to have_content 'コメントしました！'
    end
    it 'fill nothing in comment form' do
      fill_in "#{avatar.user.name}さんのアバターへコメント(最大40文字)", with: ''
      click_on 'コメント'
      expect(page).to have_content 'フォームに入力してください'
    end
    it 'removes field' do
      find('.fa-times-circle').click
      sleep 0.5
      expect(page).to_not have_css '.upload-field'
    end
  end
  pending 'can not load comment writtten by Vue' do
    describe 'destroy comment', js: true do
      let!(:me) { create(:user) }
      let!(:others) { create(:user) }
      let!(:avatar) { create(:avatar, user: others, public: true) }
      let!(:my_comment) { create(:comment, avatar: avatar, user: me, content: 'my comment') }
      let!(:others_comment) { create(:comment, avatar: avatar, user: others, content: 'others comment') }
      before do
        sign_in me
        visit user_path(others)
        find('div[id=avatar-comment]').click
      end
      it { expect(page).to have_content 'my comment' }
      it { expect(page).to have_content 'others comment' }
      context 'try to destroy my comment' do
        before do
          # click ok because confirmation form is appeared
          accept_confirm do
            # find the icon which has link to delete comment
            find(".comment#{my_comment.id}").find('.fa-trash-alt').click
          end
        end
        it { expect(page).to_not have_content 'my comment' }
      end

      context 'try to destroy others comment' do
        it 'exists link to delete comment at my comment part' do
          within(:css, ".comment#{my_comment.id}") do
            expect(page).to have_css '.fa-trash-alt'
          end
        end
        it 'does not exist link to delete comment at others comment part' do
          within(:css, ".comment#{others_comment.id}") do
            expect(page).to_not have_css '.fa-trash-alt'
          end
        end
      end
    end
  end
end
