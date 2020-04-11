# frozen_string_literal: true

class AvatarsController < ApplicationController
  include AvatarsHelper
  def new
    @image = 'なし'
  end

  def show; end

  def create
    @image = params[:picture].read
    Avatar.new(@image)
    render 'avatars/new'
  end

  def destroy; end
end
