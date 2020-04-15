# frozen_string_literal: true

class UsersController < ApplicationController
  def index; end

  def show
    @user = User.find(params[:id])
    @avatars = @user.avatars.page(params[:page]).per(1)
  end

  def new; end

  def edit; end
end
