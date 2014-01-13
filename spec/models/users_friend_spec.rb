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

require 'spec_helper'

describe UsersFriend do
  pending "add some examples to (or delete) #{__FILE__}"
end
