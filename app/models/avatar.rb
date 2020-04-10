# frozen_string_literal: true

class Avatar < ApplicationRecord
  belongs_to :user
  validates :user_id, presence: true
end
