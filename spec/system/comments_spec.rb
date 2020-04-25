# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Comments', type: :system do
  describe 'create comment' do
    let!(:me) { create(:user) }
    let!(:others) { create(:user) }
    let!(:avatar) { create(:avatar, user: others) }
    before do
      sign_in me
      visit user_path(others)
    end
    it { expect(page).to have_button 'コメント' }
    context 'fill something in comment form' do
      before do
        fill_in 'comment[content]', with: 'LGTM'
        click_on 'コメント'
      end
      it { expect(page).to have_content 'コメントしました！' }
      it { expect(page).to have_content 'LGTM' }
    end
    context 'fill nothing in comment form' do
      before do
        fill_in 'comment[content]', with: ''
        click_on 'コメント'
      end
      it { expect(page).to have_content '書き込めませんでした' }
    end
  end
  describe 'destroy comment' do
    let!(:me) { create(:user) }
    let!(:others) { create(:user) }
    let!(:avatar) { create(:avatar, user: others) }
    let!(:my_comment) { create(:comment, avatar: avatar, user: me, content: 'my comment') }
    let!(:others_comment) { create(:comment, avatar: avatar, user: others, content: 'others comment') }
    before do
      sign_in me
      visit user_path(others)
    end
    it { expect(page).to have_content 'my comment' }
    it { expect(page).to have_content 'others comment' }
    context 'try to destroy my comment' do
      before do
        # find the icon which has link to delete comment
        find(".comment#{my_comment.id}").find('.fa-trash-alt').click
        # click ok because confirmation form is appeared
        page.driver.browser.switch_to.alert.accept
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
