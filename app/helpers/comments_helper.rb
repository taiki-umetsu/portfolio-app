# frozen_string_literal: true

module CommentsHelper
  def comment_user?(comment)
    current_user == comment.user
  end
end
