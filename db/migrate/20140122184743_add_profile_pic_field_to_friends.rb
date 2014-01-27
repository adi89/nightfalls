class AddProfilePicFieldToFriends < ActiveRecord::Migration
  def change
    add_column :friends, :profile_pic, :string
  end
end
