# frozen_string_literal: true

FactoryBot.define do
  factory :user, aliases: [:owner] do
    sequence(:name) { |n| "user#{n}" }
    sequence(:email) { |n| "user#{n}@example.com" }
    password { 'password' }
  end
end
