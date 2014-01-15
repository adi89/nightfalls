module ApplicationHelper

  def twitter_user_link(username)
    link_to(username, "https://twitter.com/#{username}", class: 'user-link')
  end

  def proper_date(date)
    "<i>updated #{time_ago_in_words(date)} ago</i>".html_safe
  end

  def twitter_message_w_links(text)
    Twitter::Autolink.auto_link(text).html_safe
  end
end
