# frozen_string_literal: true

class AvatarsController < ApplicationController
  def new
    @image = 'なし'
  end

  def show; end

  def create
    @image = params[:picture]
    render 'avatars/new'
  end
end
