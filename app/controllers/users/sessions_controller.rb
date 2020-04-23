# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  def new
    @link_token = params['linkToken'] if line_user?
    super
  end

  # POST /resource/sign_in
  def create
    super
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: [:link_token])
  end

  def after_sign_in_path_for(resource)
    if line_user?
      new_line_bot_path(linkToken: params['linkToken'], user_id: resource.id)
    else
      user_path(resource)
    end
  end
end
