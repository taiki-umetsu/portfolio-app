# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Likes', type: :system do
  describe 'create like' do
    let!(:me) { create(:user) }
    let!(:others) { create(:user) }
    let!(:avatar) { create(:avatar, user: others) }
    before do
      sign_in me
      visit user_path(others)
    end
    it 'confirms the number of likes counter' do
      within(:css, '.avatar-info') do
        expect(page).to have_content 0
      end
    end
    it { expect(page).to have_css '#heart' }
    context 'click like button' do
      before do
        find('#heart').click
      end
      it 'changes the number of likes counter' do
        within(:css, '.avatar-info') do
          expect(page).to have_content 1
        end
      end
    end
  end
  describe 'destroy comment' do
    let!(:me) { create(:user) }
    let!(:others) { create(:user) }
    let!(:avatar) { create(:avatar, user: others) }
    let!(:my_like) { create(:like, avatar_id: avatar.id, user_id: me.id) }
    before do
      sign_in me
      visit user_path(others)
    end
    it 'confirms the number of likes counter' do
      within(:css, '.avatar-info') do
        expect(page).to have_content 1
      end
    end
    context 'try to destroy my like' do
      before do
        find('#heart').click
      end
      it 'decreases the number of likes counter' do
        within(:css, '.avatar-info') do
          expect(page).to have_content 0
        end
      end
    end
  end
end
