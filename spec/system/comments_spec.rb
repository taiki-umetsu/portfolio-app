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
      find('div[id=avatar-comment]').click
      find('div[id=tab-comment').find('div[id=comment-create-btn').find('button').click
      sleep 0.5
    end
    it { expect(page).to have_button 'コメント' }
    context 'fill something in comment form' do
      before do
        fill_in 'comment[content]', with: 'LGTM'
        click_on 'コメント'
      end
      it { expect(page).to have_content 'コメントしました！' }
    end
    context 'fill nothing in comment form' do
      before do
        fill_in 'comment[content]', with: ''
        click_on 'コメント'
      end
      it { expect(page).to_not have_content 'コメントしました！' }
      it { expect(page).to have_xpath("//textarea[@required='required']") }
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
