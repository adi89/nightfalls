# == Schema Information
#
# Table name: friends
#
#  id         :integer          not null, primary key
#  username   :string(255)
#  created_at :datetime
#  updated_at :datetime
#

Fabricator(:friend) do
  username Faker::Name.first_name
end