# frozen_string_literal: true

class ApplicationController < ActionController::Base
  add_flash_types :success, :info, :warning, :danger

  def line_user?
    params['linkToken'].present?
  end
end
