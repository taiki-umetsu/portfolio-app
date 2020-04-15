# frozen_string_literal: true

module ApplicationHelper
  def qrcode(text)
    qr = RQRCode::QRCode.new(text)
    qr.as_png.to_data_url
  end
end
