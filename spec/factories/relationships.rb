# frozen_string_literal: true

FactoryBot.define do
  factory :relationship do
    association :followed
    association :follower
  end
end
