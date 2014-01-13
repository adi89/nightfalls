# == Schema Information
#
# Table name: tweets
#
#  id          :integer          not null, primary key
#  username    :string(255)
#  text        :string(255)
#  tweet_code  :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  state       :string(255)
#  category_id :integer
#

# == Schema Information
#
# Table name: tweets
#
#  id          :integer          not null, primary key
#  username    :string(255)
#  text        :string(255)
#  tweet_code  :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  state       :string(255)
#  category_id :integer
#
class Tweet < ActiveRecord::Base
  include TwitterClient
  validates :tweet_code, uniqueness: true, unless: Proc.new{|c| c.tweet_code.blank?}
  validates :text, uniqueness: true
  belongs_to :category

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

  def self.category_sort(id)
    Tweet.where(category_id: "#{id}")
  end

  def self.save_tweets(tweet, options = {})
    # dedupe
    state = options[:state] || 'irrelevant'
    if options[:category_id]
      t = Tweet.find_or_initialize_by(tweet_code: tweet_code(tweet))
      if t.new_record?
        t.text = full_text(tweet)
        t.username = username(tweet)
        t.state = state
        t.save
        puts "tweet saved"
      end
      category = Category.find(options[:category_id])
      unless category.tweets.include? t
        category.tweets << t
        puts "Tweet put in #{category.name}"
      end
    else
      t = Tweet.create(username: username(tweet), text: full_text(tweet), tweet_code: tweet_code(tweet), state: state)
    end
    t
  end

  def self.tweet_scan(minutes)
    where("created_at > '#{Time.at(minutes_calculation(minutes))}'")
  end

  def self.recent_tweets(days)
    where("created_at > '#{days_ago(days)}'")
  end

  private
  def self.set_tweet_timeline
    fetch_all_tweets.collect{|tweet_data| self.save_tweets(tweet_data, {})}
  end

  def self.days_ago(days)
    Time.at(days_calculation(days))
  end

  def self.days_calculation(days)
    Time.now.to_i - (days * 3600 * 24)
  end

  def self.created_at_offset_factor
    3600 * 5 #5 hour pg offset's created
  end

  def self.minutes_calculation(minutes)
    Time.now.to_i + created_at_offset_factor - (60 * minutes) #5 hour offset
  end

  def self.parse_hash(tweet, attribute)
    hashify(tweet)[attribute]
  end

  def self.collect_strings(collection)
    collection.map!{|tweet| corpse_string(tweet, 'text')}
  end

  def self.hashify(tweet)
    JSON.load(tweet.to_json)
  end

  def self.corpse_string(tweet, attribute)
    hash = Hash.new
    hash[attribute] = parse_hash(tweet, attribute)
    hash[attribute]
  end


  def self.dedupe
    # find all models and group them on keys which should be common
    grouped = all.group_by{|tweet| [tweet.tweet_code] }
    grouped.values.each do |duplicates|
      # the first one we want to keep right?
      first_one = duplicates.shift # or pop for last one
      # if there are any more left, they are duplicates
      # so delete all of them
      duplicates.each{|double| double.destroy} # duplicates can now be destroyed
    end
  end

end
#ajax request, save to database, and do an every 5 minute thing for an update. first see if it's relevant. to nightlife, and see the avg rate to get that.
