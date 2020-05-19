# frozen_string_literal: true

module Api
  module V1
    class AvatarsController < ApiController
      before_action :authenticate_user!, only: %i[destroy]
      before_action :correct_user, only: [:destroy]
      rescue_from ActiveRecord::RecordNotFound do |_exception|
        render json: { error: '404 not found' }, status: :not_found
      end

      def index
        avatars = Avatar.where(public: true).page(params[:avatar_page]).per(1)
        data(avatars, 'avatarIndex')
        render json: data(avatars, 'avatarIndex')
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

      def update
        avatar = Avatar.find(params[:id])
        avatar.public = update_params[:avatar_public] unless update_params[:avatar_public].nil?
        avatar.message = update_params[:message] unless update_params[:message].nil?
        data = avatar.save ? 'OK' : 'NG'

        render json: data
      end

      def destroy
        data = if @avatar.destroy
                 'OK'
               else
                 'NG'
               end
        render json: data
      end

      private

      def liked?(avatar)
        signed_in? ? current_user.liking.include?(avatar) : false
      end

      def update_params
        params.permit(:avatar_public, :message, :id)
      end

      def correct_user
        @avatar = current_user.avatars.find_by(id: params[:id])
        return unless @avatar.nil?

        render json: 'アバターの削除権限がありません'
      end
    end
  end
end
