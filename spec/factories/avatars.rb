# frozen_string_literal: true

FactoryBot.define do
  factory :avatar do
    association :user
    trait :today do
      created_at { 1.hour.ago }
    end
    trait :yesterday do
      created_at { 1.day.ago }
    end
  end
end
