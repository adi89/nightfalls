module ApplicationHelper

  def twitter_user_link(username)
    link_to(username, "https://twitter.com/#{username}")
  end

  def proper_date(date)
    "#{time_ago_in_words(date)} ago"
  end

  def twitter_message_w_links(text)
    Rinku.auto_link(text).html_safe
  end
end
