# frozen_string_literal: true

class AvatarsController < ApplicationController
  include AvatarsHelper
  before_action :authenticate_user!, only: %i[create destroy]
  before_action :correct_user, only: [:destroy]
  before_action :privete?, only: %i[show markerless_ar]

  def show
    if comments = @avatar.comments.first(15)
      @comments = []
      comments.each do |c|
        text = c.content
        @comments << "#{text[0..19]}\n#{text[20..39]}\n#{text[40..59]}"
      end
    end
    return unless m = @avatar.message

    @message = "#{m[0..9]}\n#{m[10..19]}\n#{m[20..29]}\n#{m[30..39]}"
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
    avatar.public = boolean(update_params[:public])
    avatar.message = update_params[:message]
    flash[:success] = if avatar.save
                        'アップデートしました'
                      else
                        'アップデートできませんでした'
                      end
    redirect_to request.referer || current_user
  end

  def markerless_ar
    @user = @avatar.user
  end

  private

  def avatar_params
    params.permit(:picture)
  end

  def update_params
    params.require(:avatar).permit(:public, :message)
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

  def privete?
    @avatar = Avatar.find(params[:id])
    are_you_owner?(@avatar) unless @avatar.public?
  end

  def are_you_owner?(avatar)
    return if user_signed_in? && current_user == avatar.user

    flash[:danger] = 'アバターの閲覧権限がありません'
    redirect_to root_url
  end
end
