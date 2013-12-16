module TwitterStream
  extend ActiveSupport::Concern

  module ClassMethods
    def stream
      Twitter::Streaming::Client.new do |config|
        config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
        config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
        config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
        config.access_token_secret = ENV['TWITTER_ACCESS_TOKEN_SECRET']
      end
    end

    def filter_stream
      stream.user do |object|
        tweet_response(object)
      end
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

    def classify_tweet(object)
      if nightlife?(object)
        puts 'nightlife'
        save_tweets(object, {state: 'nightlife'})
      else
        puts 'irrelevant'
        save_tweets(object, {state: 'irrelevant'})
      end
    end

    def nightlife?(object)
      CLASSIFIER.classify(object.full_text) == :night
    end

    def username(tweet)
      tweet.user.screen_name
    end

    def print_tweet(tweet)
      puts "#{username(tweet)} #{full_text(tweet)}"
    end
    #when we get the thing we want to stream we may want to run this in the background and send over the message so that we can stream what's going on. when the document is ready an ajax requestis perfomred which goes to an asynchronous worker, this worker should get the message, but then it should
  end
end
