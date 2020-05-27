# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApiController
      rescue_from ActiveRecord::RecordNotFound do |_exception|
        render json: { error: '404 not found' }, status: :not_found
      end

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
        render json: current_user.valid_password?(params[:user][:current_password])
      end

      private

      def updata_params
        params.permit(:id, :image)
      end
    end
  end
end
