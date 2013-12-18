class Category < ActiveRecord::Base
  has_many :tweets
  accepts_nested_attributes_for :tweets
end
