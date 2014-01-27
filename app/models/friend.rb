# == Schema Information
#
# Table name: friends
#
#  id          :integer          not null, primary key
#  username    :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  profile_pic :string(255)
#

class Friend < ActiveRecord::Base
  has_many :users_friends
  has_many :users, through: :users_friends
  validates_uniqueness_of :username
  has_many :tweets
  include FriendApi
  # now the logic is, if the user has

  private

  def self.save_friends(options = {})
    new_friends = []
    fetch_all_friends(options).each do |friend|
      person = find_or_initialize_by(username: friend[:username])
      person.profile_pic = friend[:profile_pic] if person.new_record?
      new_friends.push(person)
    end
    new_friends
  end

  def self.find_or_create_from_username(username)
    friend  = self.find_or_initialize_by(username: username)
    unless friend.profile_pic?
      friend.profile_pic = get_profile_pic(username)
    end
    friend.save
    friend
  end

  def self.add_tweets(tweets)
    tweets.each do |tweet|
      add_tweet(tweet)
    end
  end

  def self.add_tweet(tweet)
    friend = self.find_or_create_from_username(tweet.username)
    friend.tweets << tweet
  end
  #fetch all friends lets us get the usernames of all these people. the usernames are already estables records in friends. we can loop throguh friends and make calls in order to get the urls. we just need to get the pictures of those in gobunga.

  #also future people can have twitter pics as well.

  # def self.call_client(options)
  #   client(options)
  # end

  # def self.follow_user(options)
  #   call_client(options).follow(options[:username])
  # end

  # def self.unfollow_user(options)
  #   call_client(options).follow(options[:username])
  # end

  # def self.fetch_all_friends(options = {})
  #   all_friends_list(options).flatten
  # end

  # def self.all_friends_list(options = {})
  #   friend_list = []
  #   friend_groups(options).each do |group_ids|
  #     friend_list.push(friend_usernames(options.merge(group: group_ids)))
  #     # this method should return usernames
  #   end
  #   friend_list
  # end

  # def self.friend_usernames(options = {})
  #   friends(options).collect{|i| {username: i.username, profile_pic: i.profile_image_url.site + i.profile_image_url.path}}
  # end

  # def self.friend_ids_data(options = {})
  #   call_client(token: options[:token], token_secret: options[:token_secret]).friend_ids
  # end

  # def self.friend_ids(options = {})
  #   friend_ids_data(options).attrs[:ids]
  # end

  # def self.friend_groups(options = {})
  #   friend_ids(options).each_slice(100).to_a
  # end

  # def self.friends(options = {})
  #   call_client(token: options[:token], token_secret: options[:token_secret]).users(options[:group])
  # end

  def self.dedupe
    # find all models and group them on keys which should be common
    grouped = all.group_by{|friend| [friend.username] }
    grouped.values.each do |duplicates|
      # the first one we want to keep right?
      first_one = duplicates.shift # or pop for last one
      # if there are any more left, they are duplicates
      # so delete all of them
      duplicates.each{|double| double.destroy} # duplicates can now be destroyed
    end
  end

end
