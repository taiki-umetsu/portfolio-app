# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!, only: :show
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
end
