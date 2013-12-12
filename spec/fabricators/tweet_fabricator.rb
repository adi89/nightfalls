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
#  state      :string(255)
#

Fabricator(:tweet) do
  username 'mr_adisingh'
  text 'phd party tonight at 11!!!'
  tweet_code Faker::Product.letters(10)
end