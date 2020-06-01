# frozen_string_literal: true

class ApiController < ActionController::API
  # protect_from_forgery with: :null_session
  rescue_from ActiveRecord::RecordNotFound do |_exception|
    render json: { error: '404 not found' }, status: :not_found
  end
  def data(avatars, key)
    data = { key => [] }
    avatars.each do |a|
      data[key] << {
        avatar_id: a.id,
        avatar_public: a.public,
        avatar_field: true,
        created_at: a.created_at,
        user_name: a.user.name,
        user_image: a.user.image.attached? ? url_for(a.user.image) : false,
        user_id: a.user.id,
        like_count: a.likes.count,
        like_id: signed_in? ? current_user.likes.find_by(avatar_id: a.id)&.id || false : false,
        comment_id: signed_in? ? current_user.comments.find_by(avatar_id: a.id)&.id || false : false,
        comment_count: a.comments.count,
        comment_field: false,
        message_board_field: false
      }
    end
    data
  end

  def current_user?(user)
    current_user == user
  end
end
