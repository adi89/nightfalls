# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  list       :string(255)
#  state      :string(255)
#

class Category < ActiveRecord::Base
  has_many :tweets
  accepts_nested_attributes_for :tweets

  state_machine :state, initial: :low do
    event :high do
      transition all => :high
    end
    event :low do
      transition all => :low
    end
  end

  def self.low_priority
    where(:state => 'low')
  end

  def self.high_priority
    where(:state => 'high')
  end

  def self.list(list)
    find_by_name(list)
  end
end
