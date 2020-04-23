# frozen_string_literal: true

class CreateLineBots < ActiveRecord::Migration[6.0]
  def change
    create_table :line_bots do |t|
      t.belongs_to :user, index: { unique: true }, foreign_key: true
      t.string :line_user_id, index: { unique: true }
      t.timestamps
    end
  end
end
