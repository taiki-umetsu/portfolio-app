# frozen_string_literal: true

FactoryBot.define do
  factory :avatar do
    association :user
  end
end
