class TweetsController < ApplicationController

  def index
    if request.xhr?
      @tweets = Tweet.nightlife.tweet_scan(1).order('created_at desc')
      if @tweets.present?
        render "tweet", layout: false
      else
        render nothing: true
      end
    else
      @tweets = Tweet.nightlife.recent_tweets(2).order('created_at desc')
      TweetsWorker.perform_async
    end
  end
end

#right now, we get a block of tweets. these blocks of tweets come from the tweet scan method, which look at tweets created in the past minute.