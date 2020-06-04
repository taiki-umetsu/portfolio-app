# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApiController
      def update
        user = User.find(updata_params[:id])
        user.image = updata_params[:image]
        user.save
        image = user.image.attached? ? url_for(user.image) : false
        render json: image
      end

      def image
        user = User.find(params[:id])
        image = user.image.attached? ? url_for(user.image) : false
        render json: image
      end

      def show
        user = User.find(params[:id])
        avatars = if current_user?(user)
                    user.avatars.page(params[:avatar_page]).per(1)
                  else
                    user.avatars.where(public: true).page(params[:avatar_page]).per(1)
                  end
        render json: data(avatars, 'userShow')
      end

      def liking
        user = User.find(params[:id])
        avatars = user.liking.where(public: true).page(params[:avatar_page]).per(1)
        render json: data(avatars, 'userLiking')
      end

      def check_password
        if user_signed_in?
          render json: current_user.valid_password?(params[:user][:current_password])
        else
          user = User.find_by(email: params[:email])
          data = user.present? ? user.valid_password?(params[:password]) : false
          render json: data
        end
      end

      def following
        user = User.find(params[:id])
        following = user.following.page(params[:follow_page]).per(10)
        render json: data_follow(following)
      end

      def followers
        user = User.find(params[:id])
        followers = user.followers.page(params[:follow_page]).per(10)
        render json: data_follow(followers)
      end

      private

      def updata_params
        params.permit(:id, :image)
      end

      def data_follow(follow)
        data = []
        follow.each do |f|
          data << {
            user_id: f.id,
            user_name: f.name
          }
        end
        data
      end
    end
  end
end
