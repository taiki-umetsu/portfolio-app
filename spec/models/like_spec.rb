# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Like, type: :model do
  let(:user) { create(:user) }
  let(:avatar) { create(:avatar) }
  let(:comment) { create(:comment) }
  describe 'validation' do
    it { is_expected.to validate_presence_of :user_id }
    it { is_expected.to validate_presence_of :avatar_id }
  end
  describe 'association' do
    it { is_expected.to belong_to :avatar }
    it { is_expected.to belong_to :user }
  end
  describe 'dependent: :destroy' do
    let!(:like) { create(:like, avatar_id: avatar.id, user_id: user.id) }
    it { expect { user.destroy }.to change(Like, :count).by(-1) }
    it { expect { avatar.destroy }.to change(Like, :count).by(-1) }
  end
end
