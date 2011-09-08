class Number < ActiveRecord::Base
  has_many :assignments
  has_many :users, :through => :assignments, :uniq => true
  accepts_nested_attributes_for :users
end
