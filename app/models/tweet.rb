# == Schema Information
#
# Table name: tweets
#
#  id         :integer          not null, primary key
#  username   :string(255)
#  text       :string(255)
#  tweet_code :string(255)
#  created_at :datetime
#  updated_at :datetime
#
class Tweet < ActiveRecord::Base
  validates_uniqueness_of :tweet_code, unless: Proc.new{|c| c.tweet_code.blank?}

  state_machine :state, initial: :irrelevant do
    event :nightlife do
      transition all => :nightlife
    end
    event :irrelevant do
      transition all => :irrelevant
    end
  end

  def self.client
    Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
      config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
      config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
      config.access_token_secret = ENV['TWITTER_ACCESS_TOKEN_SECRET']
    end
  end

  def self.collect_strings(collection)
    collection.map!{|tweet| corpse_string(tweet, 'text')}
  end

  def self.hashify(tweet)
    JSON.load(tweet.to_json)
  end

  def self.parse_hash(tweet, attribute)
    hashify(tweet)[attribute]
  end

  def self.remove_keys(hash)
    hash.delete('username')
    hash.delete('state')
    hash
  end

  def self.corpse_string(tweet, attribute)
    hash = Hash.new
    hash[attribute] = parse_hash(tweet, attribute)
    hash[attribute]
  end

  def self.nightlife
    Tweet.where(state: 'nightlife')
  end

  def self.irrelevant
    Tweet.where(state: 'irrelevant')
  end

  def self.home_timeline_data
    client.home_timeline(:count => 200)
  end

  def self.user_timeline_data
    client.user_timeline('NYNightlife', count: 200)
  end

  def self.set_tweet_timeline
    fetch_all_tweets.collect{|tweet_data| self.save_tweets(tweet_data)}
  end

  def self.save_tweets(tweet)
    Tweet.create(username: username(tweet), text: full_text(tweet), tweet_code: tweet_code(tweet))
  end

  def self.full_text(tweet)
    tweet.full_text
  end

  def self.tweet_code(i)
    "#{i.id}"
  end

  def self.username(tweet)
    tweet.user.screen_name
  end

  def self.collect_with_max_id(collection=[], max_id=nil, &block)
    response = yield max_id
    collection += response
    response.empty? ? collection.flatten : collect_with_max_id(collection, response.last.id - 1, &block)
  end

  def self.fetch_all_tweets
    collect_with_max_id do |max_id|
      options = {:count => 200, :include_rts => true}
      options[:max_id] = max_id unless max_id.nil?
      client.user_timelime('NYNightlife', options)
    end
  end

end
