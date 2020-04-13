# frozen_string_literal: true

class AvatarsController < ApplicationController
  include AvatarsHelper

  def show
    @avatar = Avatar.find(params[:id])
  end

  def create
    image = params[:picture].read
    avatar = current_user.avatars.build
    if avatar.save
      avatar.generate(image)
      redirect_to root_url
    else
      render 'users/show'
    end
  end

  def destroy; end
end
