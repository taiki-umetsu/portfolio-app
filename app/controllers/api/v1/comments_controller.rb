# frozen_string_literal: true

module Api
  module V1
    class CommentsController < ApiController
      before_action :authenticate_user!, only: %i[create destroy]
      before_action :your_comment?, only: %i[destroy]

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

      def your_comment?
        return if Comment.find(params[:id]).user_id == current_user.id

        render json: 'コメントの削除権限がありません'
      end
    end
  end
end
