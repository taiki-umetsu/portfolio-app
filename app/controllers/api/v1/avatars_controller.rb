# frozen_string_literal: true

module Api
  module V1
    class AvatarsController < ApiController
      before_action :authenticate_user!, only: %i[create destroy]
      before_action :correct_user, only: [:destroy]

      def index
        avatars = Avatar.where(public: true).page(params[:avatar_page]).per(1)
        data(avatars, 'avatarIndex')
        render json: data(avatars, 'avatarIndex')
      end

      def create
        if avatar_params.empty?
          render json: '画像がありません'
        else
          image = avatar_params[:image].read
          avatar = current_user.avatars.create
          if avatar.generate(image)
            render json: data([avatar], 'userShow')
          else
            avatar.destroy
            render json: '正面を向いている顔画像を投稿して下さい'
          end
        end
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
                 @avatar.destroy_s3_file
                 'OK'
               else
                 'NG'
               end
        render json: data
      end

      def likers
        avatar = Avatar.find(params[:id])
        likers = avatar.likers.page(params[:users_page]).per(10)
        render json: data_users(likers)
      end

      def comments
        avatar = Avatar.find(params[:id])
        comments = avatar.comments.page(params[:comment_page]).per(10)
        data = []
        comments.each do |c|
          data << {
            comment_id: c.id,
            content: c.content,
            created_at: c.created_at,
            user_name: c.user.name,
            user_id: c.user.id
          }
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

      def avatar_params
        params.permit(:image)
      end
    end
  end
end
