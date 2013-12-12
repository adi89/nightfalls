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

require 'spec_helper'

describe Tweet do
  pending "add some examples to (or delete) #{__FILE__}"
end
