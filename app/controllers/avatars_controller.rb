# frozen_string_literal: true

class AvatarsController < ApplicationController
  include AvatarsHelper
  before_action :private?, only: %i[show markerless_ar]
  before_action :authenticate_user!, only: :likers

  def show
    if comments = @avatar.comments.first(15)
      @comments = []
      comments.each do |c|
        text = c.content
        @comments << "#{text[0..19]}\n#{text[20..39]}\n#{text[40..59]}"
      end
    end
    if m = @avatar.message
      @message = "#{m[0..9]}\n#{m[10..19]}\n#{m[20..29]}\n#{m[30..39]}"
    end
    render layout: false
  end

  def markerless_ar
    @user = @avatar.user
    render layout: false
  end

  def likers
    @title = 'いいねしたアカウント'
    avatar = Avatar.find(params[:id])
    @api = likers_api_v1_avatar_path(avatar)
    @url = request.referer || root_url
    render template: 'users/show_group'
  end

  private

  def private?
    @avatar = Avatar.find(params[:id])
    are_you_owner?(@avatar) unless @avatar.public?
  end

  def are_you_owner?(avatar)
    return if user_signed_in? && current_user == avatar.user

    flash[:danger] = 'アバターの閲覧権限がありません'
    redirect_to root_url
  end
end
