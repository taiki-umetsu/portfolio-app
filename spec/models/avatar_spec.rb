# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Avatar, type: :model do
  let(:user) { create(:user) }
  let(:avatar) { create(:avatar, user: user) }

  describe 'association' do
    it { is_expected.to belong_to :user }
    it { is_expected.to have_many :comments }
    it { is_expected.to have_many :likes }
  end
  describe 'validation' do
    it { expect(avatar).to be_valid }
    it { expect(build(:avatar, user_id: nil)).to_not be_valid }
    it { is_expected.to validate_length_of(:message).is_at_most(40) }
  end
  describe 'dependent: :destroy' do
    let!(:avatar) { create(:avatar, user: user) }
    it { expect { user.destroy }.to change(Avatar, :count).by(-1) }
  end
  describe 'order created_at: desc' do
    let!(:new_avatar) { create(:avatar, :today, user: user) }
    let!(:old_avatar) { create(:avatar, :yesterday, user: user) }
    it { expect(user.avatars.count).to eq 2 }
    it { expect(Avatar.all.count).to eq user.avatars.count }
    it { expect(user.avatars.first).to eq new_avatar }
    it { expect(user.avatars.second).to eq old_avatar }
  end
end
