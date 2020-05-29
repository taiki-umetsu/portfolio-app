# frozen_string_literal: true

class ApplicationController < ActionController::Base
  add_flash_types :success, :info, :warning, :danger

  def line_user?
    params['linkToken'].present?
  end

  def current_user?(user)
    current_user == user
  end

  def set_base_url
    @base_url = if Rails.env.test?
                  "http://127.0.0.1:#{request.port}"
                else
                  ENV['BASE_URL']
                end
  end
end
