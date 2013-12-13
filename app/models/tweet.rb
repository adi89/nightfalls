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
  include TwitterStream
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
    fetch_all_tweets.collect{|tweet_data| self.save_tweets(tweet_data, {})}
  end

  def self.save_tweets(tweet, options = {})
    if options[:state]
      Tweet.create(username: username(tweet), text: full_text(tweet), tweet_code: tweet_code(tweet), state: 'nightlife')
       puts 'tweet saved'
    else
      Tweet.create(username: username(tweet), text: full_text(tweet), tweet_code: tweet_code(tweet))
    end
  end

  def self.full_text(tweet)
    tweet.full_text
  end

  def self.tweet_code(i)
    "#{i.id}"
  end

  def self.tweet_scan(minutes)
    where("created_at > '#{Time.at(minutes_calculation(minutes))}'")
  end

  def self.minutes_calculation(minutes)
    Time.now.to_i + created_at_offset_factor - (60 * minutes) #5 hour offset
  end

  def self.created_at_offset_factor
    3600 * 5 #5 hour pg offset's created
  end

  def self.recent_tweets(days)
    where("created_at > '#{days_ago(days)}'")
  end

  def self.days_ago(days)
    Time.at(days_calculation(days))
  end

  def self.days_calculation(days)
    Time.now.to_i - (days * 3600 * 24)
  end
#ajax request, save to database, and do an every 5 minute thing for an update. first see if it's relevant. to nightlife, and see the avg rate to get that.

end
