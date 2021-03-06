# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  require 'dotenv/load'
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]
  before_action :set_base_url, only: :edit
  before_action :forbid_test_user, only: %i[update destroy]

  # GET /resource/sign_up
  def new
    @link_token = params['linkToken'] if line_user?
    super
  end

  # POST /resource
  def create
    super
  end

  # GET /resource/edit
  def edit
    super
  end

  # PUT /resource
  def update
    super
  end

  # DELETE /resource
  def destroy
    super
  end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:sign_up, keys: [:link_token])
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:image])
  end

  # The path used after sign up.
  def after_sign_up_path_for(resource)
    if line_user?
      new_line_bot_path(linkToken: params['linkToken'], user_id: resource.id)
    else
      user_path(resource)
    end
  end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end

  def forbid_test_user
    return unless resource.email == 'test.user@example.com'

    flash[:danger] = 'テストユーザーのため変更できません'
    redirect_to request.referer || root_url
  end
end
