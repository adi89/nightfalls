require 'twitter-text'

module TweetsHelper

  def twitter_user_link(username)
    link_to(username, "https://twitter.com/#{username}", class: 'user-link')
  end

  def proper_date(date)
    "<i>updated #{time_ago_in_words(date)} ago</i>".html_safe
  end

  def twitter_message_w_links(text)
    Twitter::Autolink.auto_link(text).html_safe
  end

  def tweet_user_link(username)
    "https://www.twitter.com/#{username}"
  end

  def category_description(category)
    if category.present?
      case category.name
        when 'information'
          information_text
        when 'high end djs'
          dj_text
        when 'scenesters'
          scenester_text
        when 'promoters'
          promoter_text
        when 'power players'
          power_player_text
        end
      else
        nitefeed_text
      end
    end

    def nitefeed_text
      "<p>The NiteFeed is your source for up to all things Nightlife related. Tweets are gone through a filter, so you only get the good stuff - nightlife relevant tweets aggregated from all the players in the industry.</p>".html_safe
    end

    def information_text
      "<p>The information feed narrows down the focus to accounts related to both NY Nightlife news but also to relevent tech and current events.</p>".html_safe
    end

    def dj_text
      "<p>Here's what the DJs in NYC are saying. Plan your night by tracking where your favorite local DJ will be playing at.</p>".html_safe
    end

    def scenester_text
      "<p>What can be said about NY scenesters? The love to talk. And you love to listen. So do just that. Experience the controversy, the gossip, and the general tomfoolery.<p>".html_safe
    end

    def promoter_text
      "<p>Promoters: we love to hate. The serve a valuable purpose, and when caught up, they can make venue access a lot easier. See what their commmentary is on the current nightlife landscape or find a valuable piece of info that provides that right deal<p>".html_safe
    end

    def power_player_text
      "<p>These are the movers and shakers of New York Nightlife. When they talk, people listen<p>".html_safe
    end

    def last_updated(tweets)
      "<p><i>Feed last</i> #{proper_date(tweets.last.created_at)}</p>".html_safe
    end

    # def tweet_link(tweet)
    #   Friend.where(username: tweet.username).first.profile_pic
    # end
end
