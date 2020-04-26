# frozen_string_literal: true

module LikesHelper
  def your_avatar?(avatar)
    current_user?(avatar.user)
  end
end
