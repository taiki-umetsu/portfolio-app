# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    content { 'MyText' }
    avatar { nil }
    user { nil }
  end
end
