# == Schema Information
#
# Table name: users_friends
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  friend_id  :integer
#  created_at :datetime
#  updated_at :datetime
#

class UsersFriend < ActiveRecord::Base
  belongs_to :user
  belongs_to :friend
end
