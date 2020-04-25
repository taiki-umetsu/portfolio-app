# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :avatar
  belongs_to :user
  validates :avatar_id, presence: true
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  default_scope -> { order(created_at: :desc) }
end
