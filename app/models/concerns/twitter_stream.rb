module TwitterStream
  extend ActiveSupport::Concern

  module ClassMethods
    def filter_stream
      stream.user do |object|
        tweet_response(object)
      end
    end

    private
    def stream
      Twitter::Streaming::Client.new do |config|
        config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
        config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
        config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
        config.access_token_secret = ENV['TWITTER_ACCESS_TOKEN_SECRET']
      end
    end

    def classify_tweet(tweet)
      if nightlife?(tweet)
        puts 'nightlife'
        save_tweets(tweet, {state: 'nightlife'})
      else
        puts 'irrelevant'
        save_tweets(tweet, {state: 'irrelevant'})
      end
    end

    def nightlife?(tweet_data)
      CLASSIFIER.classify(tweet_data.full_text) == :night
    end

    def is_a_tweet?(object)
      object.is_a?(Twitter::Tweet) && object.full_text.is_a?(String)
    end

    def tweet_response(object)
      if is_a_tweet?(object)
        puts object.text
        classify_tweet(object)
      else
        puts 'not a tweet'
      end
    end

  end
end
