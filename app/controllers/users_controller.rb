# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!, only: %i[show followers following]
  before_action :set_base_url
  def index
    @avatars = Avatar.where(public: true).page(params[:page]).per(2)
    @comment = current_user.comments.build if user_signed_in?
  end

  def show
    @user = User.find(params[:id])
    @avatars = if current_user?(@user)
                 @user.avatars.page(params[:page]).per(1)
               else
                 @user.avatars.where(public: true).page(params[:page]).per(1)
               end
    @comment = current_user.comments.build
  end

  def following
    @title = 'フォロー中'
    @user  = User.find(params[:id])
    @api = following_api_v1_user_path(@user)
    render 'show_group'
  end

  def followers
    @title = 'フォロワー'
    @user  = User.find(params[:id])
    @api = followers_api_v1_user_path(@user)
    render 'show_group'
  end
end
