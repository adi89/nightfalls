class CreateUsersFriends < ActiveRecord::Migration
  def change
    create_table :users_friends do |t|
      t.references :user
      t.references :friend
      t.timestamps
    end
  end
end
