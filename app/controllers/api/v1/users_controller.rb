# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApiController
      rescue_from ActiveRecord::RecordNotFound do |_exception|
        render json: { error: '404 not found' }, status: :not_found
      end

      def edit
        user = User.find(params[:id])
        image = user.image.attached? ? url_for(user.image) : false
        render json: image
      end

      def update
        user = User.find(updata_params[:id])
        user.image = updata_params[:image]
        user.save
        image = user.image.attached? ? url_for(user.image) : false
        render json: image
      end

      private

      def updata_params
        params.permit(:id, :image)
      end
    end
  end
end
