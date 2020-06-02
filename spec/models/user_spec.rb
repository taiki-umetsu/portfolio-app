# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:me) { create(:user) }
  let!(:others) { create(:user) }
  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :password }
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  it { is_expected.to have_many :avatars }
  it { is_expected.to have_many :comments }
  it { is_expected.to have_many :likes }
  it 'follows and unfollows' do
    expect(me.following?(others)).to be_falsey
    me.follow(others)
    expect(me.following?(others)).to be_truthy
    expect(others.followers.include?(me)).to be_truthy
    me.unfollow(others)
    expect(me.following?(others)).to be_falsey
  end
end
