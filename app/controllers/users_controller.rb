# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!, only: :show
  def index; end

  def show
    @user = User.find(params[:id])
    @avatars = @user.avatars.page(params[:page]).per(1)
  end
end
