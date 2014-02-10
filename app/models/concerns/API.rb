module API
  extend ActiveSupport::Concern

  module ClassMethods
    def home_timeline_data(amount, options)
      client(options).home_timeline(count: amount)
    end

    def user_timeline_data(user, options)
      client(options).user_timeline(user, options)
    end

    def get_profile_pic(username)
      image_url = user_data(username).profile_image_url
      image_url.site + image_url.path
    end

    def user_data(username)
      random_client.user(username)
    end

    def random_client
      user = User.all.sample
      options = {token: user.token, token_secret: user.token_secret}
      client(options)
    end

    def list_timeline(options = {})
      client(options).list_timeline('adi_s89', options[:list], count: options[:count])
    end

    def client(options = {})
      Twitter::REST::Client.new do |config|
        config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
        config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
        config.access_token        = options[:token] || ENV['TWITTER_ACCESS_TOKEN']
        config.access_token_secret = options[:token_secret] || ENV['TWITTER_ACCESS_TOKEN_SECRET']
      end
    end

    def fetch_all_tweets(user)
      collect_with_max_id do |max_id|
        options = {:count => 200, :include_rts => true}
        options[:max_id] = max_id unless max_id.nil?
        user_timeline_data(user, options)
      end
    end

    def self.set_tweet_timeline
      fetch_all_tweets.collect{|tweet_data| self.save_tweets(tweet_data, {})}
    end

    #we want to get fetch the tweets. find or create by id. return them to the method to use. save these tweets by their

    protected

    def get_all_list_members(list)
      collect_with_max_id do |max_id|
        options = {:count => 200, :include_rts => true}
        options[:max_id] = max_id unless max_id.nil?
        client.list_members(list, options)
      end
    end

    private

    def add_members_to_list(options = {})
      client(options).add_list_members(options[:list], options[:users])
    end

    def grab_users_from_list(options = {})
      collection = options[:collection] || [] #either passed in or blank
      cursor = options[:cursor] || -1 #passed in or -1
      response = client(options).list_members(options[:list], cursor: cursor)
      screen_names = response.attrs[:users].map{|i| i[:screen_name]}
      if screen_names.empty?
        collection
      else
        collection = collection.push(screen_names).flatten.uniq
        cursor = response.next_cursor
        grab_users_from_list(collection: collection, cursor: cursor, list: options[:list])
      end
    end

    def collect_with_max_id(collection=[], max_id=nil, &block)
      response = yield max_id
      collection += response
      response.empty? ? collection.flatten : collect_with_max_id(collection, response.last.id - 1, &block)
    end

    def list_tweets_parse(options = {})
      list_tweets_data(options)
    end

    def list_tweets_data(options = {})
      max = 3
      num_attempts = 0
      begin
        num_attempts += 1
        list_timeline(options)
      rescue Twitter::Error::TooManyRequests => error
        if num_attempts <= max
          sleep error.rate_limit.reset_in
          retry
        else
          raise
        end
      end
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

  end
end
