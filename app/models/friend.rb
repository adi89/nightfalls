# == Schema Information
#
# Table name: friends
#
#  id         :integer          not null, primary key
#  username   :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Friend < ActiveRecord::Base
  has_many :users_friends
  has_many :users, through: :users_friends
  validates_uniqueness_of :username
  include TwitterClient
  # now the logic is, if the user has

  private

  def self.save_friends(options = {})
    new_friends = []
    fetch_all_friends(options).each do |friend|
      new_friends.push(Friend.new(username: friend))
    end
    new_friends
  end

  def self.call_client(options)
    client(options)
  end

  def self.follow_user(options)
    call_client(options).follow(options[:username])
  end

  def self.unfollow_user(options)
    call_client(options).follow(options[:username])
  end

  def self.fetch_all_friends(options = {})
    all_friends_list(options).flatten
  end

  def self.all_friends_list(options = {})
    friend_list = []
    friend_groups(options).each do |group_ids|
      friend_list.push(friend_usernames(options.merge(group: group_ids)))
      # this method should return usernames
    end
    friend_list
  end

  def self.friend_usernames(options = {})
    friends(options).collect{|i| i.username}
  end

  def self.friend_ids_data(options = {})
    call_client(token: options[:token], token_secret: options[:token_secret]).friend_ids
  end

  def self.friend_ids(options = {})
    friend_ids_data(options).attrs[:ids]
  end

  def self.friend_groups(options = {})
    friend_ids(options).each_slice(100).to_a
  end

  def self.friends(options = {})
    call_client(token: options[:token], token_secret: options[:token_secret]).users(options[:group])
  end

  #user now has friends.
  #next step. somone viewing tweets should see the follow button if they don't follow that user.
  #if Friend.where(tweet.username => tweet_handle) is present, else false
end
