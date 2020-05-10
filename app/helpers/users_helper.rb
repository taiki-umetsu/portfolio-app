# frozen_string_literal: true

module UsersHelper
  def public_avatars_count(user)
    user.avatars.where(public: true).count
  end
end
