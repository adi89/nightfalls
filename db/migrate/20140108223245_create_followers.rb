class CreateFollowers < ActiveRecord::Migration
  def change
    create_table :followers do |t|
      t.string :username
      t.references :user
      t.timestamps
    end
  end
end
