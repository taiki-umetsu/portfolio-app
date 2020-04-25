# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :avatar
  belongs_to :user
  validates :avatar, presence: true
  validates :user, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  default_scope -> { order(created_at: :desc) }
end
