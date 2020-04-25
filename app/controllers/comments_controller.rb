# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy]
  before_action :your_comment?, only: %i[destroy]

  def create
    comment = current_user.comments.build(create_comment_params)
    if comment.save
      flash[:success] = 'コメントしました！'
    else
      flash[:alert] = '書き込めませんでした'
    end
    redirect_to request.referer || root_url
  end

  def destroy
    comment = current_user.comments.find(params[:id])
    if comment.destroy
      flash[:success] = '削除しました！'
    else
      flash[:alert] = '削除できませんでした'
    end
    redirect_to request.referer || root_url
  end

  private

  def create_comment_params
    params.require(:comment).permit(:avatar_id, :content)
  end

  def your_comment?
    return if Comment.find(params[:id]).user_id == current_user.id

    flash[:danger] = 'コメントの削除権限がありません'
    redirect_to root_url
  end
end
