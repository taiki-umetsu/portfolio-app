# frozen_string_literal: true

class Like < ApplicationRecord
  belongs_to :user
  belongs_to :avatar
  validates :avatar_id, presence: true
  validates :user_id, presence: true
end
