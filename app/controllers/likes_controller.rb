# frozen_string_literal: true

class LikesController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy]
  before_action :your_like?, only: %i[destroy]

  def create
    like = current_user.likes.build(create_like_params)
    like.save
    redirect_to request.referer || root_url
  end

  def destroy
    like = current_user.likes.find(destroy_like_params[:id])
    like.destroy
    redirect_to request.referer || root_url
  end

  private

  def create_like_params
    params.require(:like).permit(:avatar_id)
  end

  def destroy_like_params
    params.permit(:id)
  end

  def your_like?
    return if Like.find(params[:id]).user_id == current_user.id

    flash[:danger] = 'いいねの削除権限がありません'
    redirect_to root_url
  end
end
