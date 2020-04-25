# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    sequence(:content) { |n| "comment#{n}" }
    association :avatar
    association :user
    sequence(:created_at) { |n| n.minutes.ago }
    trait :today do
      created_at { 1.hour.ago }
    end
    trait :yesterday do
      created_at { 1.day.ago }
    end
  end
end
