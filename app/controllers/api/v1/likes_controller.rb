# frozen_string_literal: true

module Api
  module V1
    class LikesController < ApiController
      rescue_from ActiveRecord::RecordNotFound do |_exception|
        render json: { error: '404 not found' }, status: :not_found
      end

      def create
        like = current_user.likes.build(avatar_id: params[:avatar_id])
        like.save
        render json: { like_id: like.id }
      end

      def destroy
        like = current_user.likes.find(params[:id])
        like.destroy
        render json: 'OK'
      end
    end
  end
end
