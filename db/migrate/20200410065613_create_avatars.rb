# frozen_string_literal: true

class CreateAvatars < ActiveRecord::Migration[6.0]
  def change
    create_table :avatars do |t|
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    add_index :avatars, %i[user_id created_at]
  end
end
