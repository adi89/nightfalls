class RemoveReferenceFromFriends < ActiveRecord::Migration
  def change
    remove_reference :friends, :user, index: true
  end
end
