# frozen_string_literal: true

module Api
  module V1
    class CommentsController < ApiController
      rescue_from ActiveRecord::RecordNotFound do |_exception|
        render json: { error: '404 not found' }, status: :not_found
      end
      def destroy
        comment = current_user.comments.find(params[:id])
        comment.destroy
        render json: 'OK'
      end
    end
  end
end
