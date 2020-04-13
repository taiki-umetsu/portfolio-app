# frozen_string_literal: true

module UsersHelper
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
    end
  end
end
