# frozen_string_literal: true

module Api
  module V1
    class LikesController < ApiController
      before_action :authenticate_user!, only: %i[create destroy]
      before_action :your_like?, only: %i[destroy]
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

      private

      def your_like?
        return if Like.find(params[:id]).user_id == current_user.id

        render json: 'いいねの削除権限がありません'
      end
    end
  end
end
