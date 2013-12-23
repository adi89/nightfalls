# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  list       :string(255)
#

Fabricator(:category) do
  name 'high end djs'
  list 'high-end-djs'
end