# frozen_string_literal: true

module Api
  module V1
    class CommentsController < ApiController
      rescue_from ActiveRecord::RecordNotFound do |_exception|
        render json: { error: '404 not found' }, status: :not_found
      end
      def create
        comment = current_user.comments.build(create_comment_params)
        comment.save
        render json: { comment_id: comment.id }
      end

      def destroy
        comment = current_user.comments.find(params[:id])
        comment.destroy
        render json: 'OK'
      end

      private

      def create_comment_params
        params.require(:comment).permit(:avatar_id, :content)
      end
    end
  end
end
