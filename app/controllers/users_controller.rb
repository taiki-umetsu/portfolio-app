# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_base_url
  def index
    @title = 'ユーザー一覧'
    @api = api_v1_users_path
    @q = User.all.ransack(params[:q])
    @searched_users = @q.result(distinct: true)

    render 'show_group'
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
