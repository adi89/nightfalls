module FriendApi
  extend ActiveSupport::Concern
  include API

  module ClassMethods
    def call_client(options)
      client(options)
    end

    def follow_user(options)
      call_client(options).follow(options[:username])
    end

    def unfollow_user(options)
      call_client(options).follow(options[:username])
    end

    def fetch_all_friends(options = {})
      all_friends_list(options).flatten
    end

    def all_friends_list(options = {})
      friend_list = []
      friend_groups(options).each do |group_ids|
        friend_list.push(friend_usernames(options.merge(group: group_ids)))
        # this method should return usernames
      end
      friend_list
    end

    def friend_usernames(options = {})
      friends(options).collect{|i| {username: i.username, profile_pic: i.profile_image_url.site + i.profile_image_url.path}}
    end

    def friend_ids_data(options = {})
      call_client(token: options[:token], token_secret: options[:token_secret]).friend_ids
    end

    def friend_ids(options = {})
      friend_ids_data(options).attrs[:ids]
    end

    def friend_groups(options = {})
      friend_ids(options).each_slice(100).to_a
    end

    def friends(options = {})
      call_client(token: options[:token], token_secret: options[:token_secret]).users(options[:group])
    end
  end
end
