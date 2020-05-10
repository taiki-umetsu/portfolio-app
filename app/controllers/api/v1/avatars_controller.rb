# frozen_string_literal: true

module Api
  module V1
    class AvatarsController < ApiController
      rescue_from ActiveRecord::RecordNotFound do |_exception|
        render json: { error: '404 not found' }, status: :not_found
      end
      def show
        avatar = Avatar.find(params[:id])
        comments = avatar.comments.page(params[:comment_page]).per(10)
        data = []
        comments.each do |c|
          data << {
            comment_id: c.id,
            content: c.content,
            created_at: c.created_at,
            user_name: c.user.name,
            user_image: c.user.image.attached? ? url_for(c.user.image) : false,
            user_id: c.user.id
          }
        end
        render json: data
      end
    end
  end
end
