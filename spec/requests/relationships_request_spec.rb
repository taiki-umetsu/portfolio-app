# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Relationships', type: :request do
  describe 'POST #create' do
    let!(:me) { create(:user) }
    let!(:others) { create(:user) }
    let!(:follow_others) { create(:relationship, follower: me, followed: others) }
    context 'not sign in user' do
      it 'try to create but be redirected to loggin form' do
        post relationships_path
        expect(response).to redirect_to(new_user_session)
      end
      it 'try to destroy but be redirected to loggin form' do
        delete relationship_path(follow_others)
        expect(response).to redirect_to(new_user_session)
      end
    end
  end
end
