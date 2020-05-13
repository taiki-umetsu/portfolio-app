# frozen_string_literal: true

module Api
  module V1
    class AvatarsController < ApiController
      rescue_from ActiveRecord::RecordNotFound do |_exception|
        render json: { error: '404 not found' }, status: :not_found
      end
      def index
        avatars = Avatar.where(public: true).page(params[:avatar_page]).per(1)
        render json: index_data(avatars)
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

      private

      def liked?(avatar)
        signed_in? ? current_user.liking.include?(avatar) : false
      end

      def index_data(avatars)
        data = []
        avatars.each do |a|
          data << {
            avatar_id: a.id,
            created_at: a.created_at,
            user_name: a.user.name,
            user_image: a.user.image.attached? ? url_for(a.user.image) : false,
            user_id: a.user.id,
            like_count: a.likes.count,
            like_id: signed_in? ? current_user.likes.find_by(avatar_id: a.id)&.id || false : false,
            comment_id: signed_in? ? current_user.comments.find_by(avatar_id: a.id)&.id || false : false,
            comment_count: a.comments.count,
            comment_field: false
          }
        end
        data
      end
    end
  end
end
