# frozen_string_literal: true

module ApplicationHelper
  def qrcode(text)
    qr = RQRCode::QRCode.new(text)
    qr.as_png.to_data_url
  end

  def current_user?(user)
    current_user == user
  end

  def app_name
    'カオリアル'
  end

  def bootstrap_alert(key)
    case key
    when 'alert'
      'warning'
    when 'notice'
      'success'
    when 'error'
      'danger'
    when 'success'
      'success'
    when 'danger'
      'danger'
    when 'warning'
      'warning'
    when 'info'
      'info'
    end
  end

  def line_user?
    params['linkToken'].present?
  end

  def user_icon(user)
    user.image.attached? ? user.image : 'default_icon.png'
  end

  def current_user_id
    user_signed_in? ? current_user.id : false
  end

  def your_avatar?(avatar)
    current_user?(avatar.user)
  end
end
