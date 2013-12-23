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

class Category < ActiveRecord::Base
  has_many :tweets
  accepts_nested_attributes_for :tweets

  def self.list(list)
    find_by_name(list)
  end
end
