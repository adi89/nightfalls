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
  include TwitterClient
  validates_uniqueness_of :tweet_code, unless: Proc.new{|c| c.tweet_code.blank?}

  state_machine :state, initial: :irrelevant do
    event :night do
      transition all => :nightlife
    end
    event :discard do
      transition all => :irrelevant
    end
  end

  def self.nightlife
    Tweet.where(state: 'nightlife')
  end

  def self.irrelevant
    Tweet.where(state: 'irrelevant')
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

  def self.corpse_string(tweet, attribute)
    hash = Hash.new
    hash[attribute] = parse_hash(tweet, attribute)
    hash[attribute]
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

end
