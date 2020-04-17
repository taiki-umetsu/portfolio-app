# frozen_string_literal: true

class AddPublicToAvatars < ActiveRecord::Migration[6.0]
  def change
    add_column :avatars, :public, :boolean, default: false, null: false
  end
end
