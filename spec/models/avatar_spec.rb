# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Avatar, type: :model do
  let(:user) { create(:user) }
  let(:avatar) { create(:avatar, user: user) }
  describe 'validation' do
    it 'is valid with a user_id' do
      expect(avatar).to be_valid
    end
    it 'is invalid with a empty user_id' do
      expect(build(:avatar, user_id: nil)).to_not be_valid
    end
  end

  describe 'when destroy user' do
    it 'destroys associated avatars' do
      user.avatars.create!
      expect { user.destroy }.to change(user.avatars, :count).by(-1)
    end
  end
end
