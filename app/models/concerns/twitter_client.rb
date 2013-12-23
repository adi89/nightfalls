module TwitterClient
  extend ActiveSupport::Concern

  module ClassMethods
    def home_timeline_data(amount)
      client.home_timeline(count: amount)
    end

    def user_timeline_data(user, options)
      client.user_timeline(user, options)
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

    def list_timeline(list, count)
      client.list_timeline(list, count: count)
    end

    def list_tweets(options = {})
      list_tweets_parse(options).each do |tweet|
        if nightlife?(tweet)
          options[:state] = 'nightlife'
          save_tweets(tweet, options)
        else
          options[:state] = 'irrelevant'
          save_tweets(tweet, options)
        end
      end
    end

#we want to get fetch the tweets. find or create by id. return them to the method to use. save these tweets by their

    def list_tweets_parse(options = {})
      list_tweets_data(options)
    end

    private
    def collect_with_max_id(collection=[], max_id=nil, &block)
      response = yield max_id
      collection += response
      response.empty? ? collection.flatten : collect_with_max_id(collection, response.last.id - 1, &block)
    end

    def list_tweets_data(options = {})
      max = 3
      num_attempts = 0
      begin
        num_attempts += 1
        list_timeline(options[:list], options[:count])
      rescue Twitter::Error::TooManyRequests => error
        if num_attempts <= max
          sleep error.rate_limit.reset_in
          retry
        else
          raise
        end
      end
    end

    def client
      Twitter::REST::Client.new do |config|
        config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
        config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
        config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
        config.access_token_secret = ENV['TWITTER_ACCESS_TOKEN_SECRET']
      end
    end

    def fetch_all_tweets
      collect_with_max_id do |max_id|
        options = {:count => 200, :include_rts => true}
        options[:max_id] = max_id unless max_id.nil?
        user_timeline_data('gobunga', options)
      end
    end

    def full_text(tweet)
      tweet.full_text
    end

    def tweet_code(tweet)
      "#{tweet.id}"
    end

    def fetch_new_tweets(amount)
      home_timeline_data(amount).each do |tweet|
        puts 'fetch'
        classify_tweet(tweet)
      end
    end

    def username(tweet)
      tweet.user.screen_name
    end

    def print_tweet(tweet)
      puts "#{username(tweet)} #{full_text(tweet)}"
    end

  end
end
