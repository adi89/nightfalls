module TwitterClient
  extend ActiveSupport::Concern

  module ClassMethods
    def home_timeline_data
      client.home_timeline(:count => 200)
    end

    def user_timeline_data(user, options)
      client.user_timeline(user, options)
    end


    def fetch_all_tweets
      collect_with_max_id do |max_id|
        options = {:count => 200, :include_rts => true}
        options[:max_id] = max_id unless max_id.nil?
        user_timeline_data('mr_adisingh', options)
      end
    end

    private
    def collect_with_max_id(collection=[], max_id=nil, &block)
      response = yield max_id
      collection += response
      response.empty? ? collection.flatten : collect_with_max_id(collection, response.last.id - 1, &block)
    end

    def full_text(tweet)
      tweet.full_text
    end

    def tweet_code(tweet)
      "#{tweet.id}"
    end


    def username(tweet)
      tweet.user.screen_name
    end

    def print_tweet(tweet)
      puts "#{username(tweet)} #{full_text(tweet)}"
    end

    def self.is_a_tweet?(object)
      object.is_a?(Twitter::Tweet) && object.full_text.is_a?(String)
    end

    def client
      Twitter::REST::Client.new do |config|
        config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
        config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
        config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
        config.access_token_secret = ENV['TWITTER_ACCESS_TOKEN_SECRET']
      end
    end
  end
end
