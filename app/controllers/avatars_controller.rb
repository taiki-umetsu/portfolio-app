# frozen_string_literal: true

class AvatarsController < ApplicationController
  include AvatarsHelper
  before_action :authenticate_user!, only: %i[create destroy]
  before_action :correct_user, only: [:destroy]

  def show
    @avatar = Avatar.find(params[:id])
  end

  def create
    if avatar_params.empty?
      flash[:alert] = '画像がありません'
      redirect_to current_user
    else
      image = avatar_params[:picture].read
      avatar = current_user.avatars.build
      if avatar.save
        avatar.generate(image)
        flash[:success] = 'アバターを作成しました！'
        redirect_to current_user
      end
    end
  end

  def destroy
    @avatar.destroy
    @avatar.destroy_s3_file
    flash[:success] = 'アバターを削除しました'
    redirect_to request.referer || root_url
  end

  def update
    avatar = Avatar.find(params[:id])
    avatar.public = boolean(public_params[:public])
    avatar.save!
    redirect_to current_user
  end

  def markerless_ar
    @avatar = Avatar.find(params[:id])
    @user = @avatar.user
  end

  private

  def avatar_params
    params.permit(:picture)
  end

  def public_params
    params.require(:avatar).permit(:public)
  end

  def correct_user
    @avatar = current_user.avatars.find_by(id: params[:id])
    return unless @avatar.nil?

    flash[:danger] = 'アバターの削除権限がありません'
    redirect_to root_url
  end

  def boolean(value)
    if value == '1'
      true
    elsif value == '0'
      false
    end
  end
end
