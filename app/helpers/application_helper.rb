module ApplicationHelper

  def twitter_user_link(username)
    link_to(username, "https://twitter.com/#{username}")
  end
end
