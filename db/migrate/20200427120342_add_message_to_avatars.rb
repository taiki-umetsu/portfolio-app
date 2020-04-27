# frozen_string_literal: true

class AddMessageToAvatars < ActiveRecord::Migration[6.0]
  def change
    add_column :avatars, :message, :text
  end
end
