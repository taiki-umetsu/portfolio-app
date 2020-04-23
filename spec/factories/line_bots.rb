# frozen_string_literal: true

FactoryBot.define do
  factory :line_bot do
    association :user
    line_user_id { 'U91eeaf62d...' }
  end
end
