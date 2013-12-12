class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.string :username
      t.string :text
      t.string :tweet_code
      t.timestamps
    end
  end
end
