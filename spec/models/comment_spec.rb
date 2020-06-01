# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:user) { create(:user) }
  let(:avatar) { create(:avatar) }
  let(:comment) { create(:comment) }
  describe 'validation' do
    it { is_expected.to validate_presence_of :avatar_id }
    it { is_expected.to validate_presence_of :user_id }
    it { is_expected.to validate_presence_of :content }
    it { is_expected.to validate_length_of(:content).is_at_most(40) }
  end
  describe 'association' do
    it { is_expected.to belong_to :avatar }
    it { is_expected.to belong_to :user }
  end
  describe 'dependent: :destroy' do
    let!(:comment) { create(:comment, avatar: avatar, user: user) }
    it { expect { user.destroy }.to change(Comment, :count).by(-1) }
    it { expect { avatar.destroy }.to change(Comment, :count).by(-1) }
  end
  describe 'order created_at: desc' do
    let!(:new_comment) { create(:comment, :today, user: user) }
    let!(:old_comment) { create(:comment, :yesterday, user: user) }
    it { expect(user.comments.count).to eq 2 }
    it { expect(Comment.all.count).to eq user.comments.count }
    it { expect(user.comments.first).to eq new_comment }
    it { expect(user.comments.second).to eq old_comment }
  end
end
