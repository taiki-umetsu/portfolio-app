# frozen_string_literal: true

class CommentsController < ApplicationController
  def create
    comment = Comment.new(create_comment_params)
    if comment.save
      flash[:success] = 'コメントしました！'
    else
      flash[:alert] = '書き込めませんでした'
    end
    redirect_to request.referer || root_url
  end

  def destroy
    comment = Comment.find(destroy_comment_params[:id])
    if comment.destroy
      flash[:success] = '削除しました！'
    else
      flash[:alert] = '削除できませんでした'
    end
    redirect_to request.referer || root_url
  end

  def create_comment_params
    params.permit(:user_id, :avatar_id, :content)
  end

  def destroy_comment_params
    params.permit(:id)
  end
end
