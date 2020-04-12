# frozen_string_literal: true

class AvatarsController < ApplicationController
  include AvatarsHelper

  def show; end

  def create
    image = params[:picture].read
    @avatar = current_user.avatars.build
    if @avatar.save
      @avatar.generate(image)
      render 'avatars/new'
    else
      render 'avatars/new'
    end
  end

  def destroy; end
end
