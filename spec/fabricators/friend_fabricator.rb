# == Schema Information
#
# Table name: friends
#
#  id          :integer          not null, primary key
#  username    :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  profile_pic :string(255)
#

Fabricator(:friend) do
  username Faker::Name.first_name
end
