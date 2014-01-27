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
  include Classification
  include TimeUtil
  belongs_to :friend
  validates :tweet_code, uniqueness: true, unless: Proc.new{|c| c.tweet_code.blank?}
  validates :text, presence: true
  belongs_to :category

  state_machine :state, initial: :irrelevant do
    event :night do
      transition all => :nightlife
    end
    event :discard do
      transition all => :irrelevant
    end
  end

  def self.unique_tweets(str)
    where("id not in (#{str})")
  end

  def self.nightlife
    where(state: 'nightlife')
  end

  def self.irrelevant
    where(state: 'irrelevant')
  end

  def self.category_sort(id)
    where(category_id: "#{id}")
  end

  def self.save_tweets(tweet, options = {})
    state = options[:state]
    if options[:category_id]
      t = self.find_or_initialize_by(tweet_code: tweet_code(tweet))
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
      Friend.add_tweet(t)
    end
    t
  end

  def self.tweet_scan(minutes)
    where("created_at > '#{Time.at(minutes_calculation(minutes))}'")
  end

  def self.recent_tweets(days)
    where("created_at > '#{days_ago(days)}'")
  end

#the question is do we want this in friend or in user?
  private

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
