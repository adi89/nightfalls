class FixFollowers < ActiveRecord::Migration
  def change
    rename_table :followers, :friends
  end
end
