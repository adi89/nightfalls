class AddFriendIdToTweets < ActiveRecord::Migration
  def change
    add_reference :tweets, :friend, index: true
  end
end
