# == Schema Information
# Schema version: 20110826221216
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  number     :string(255)
#  created_at :datetime
#  updated_at :datetime
#  group_id   :integer
#

class User < ActiveRecord::Base
  
  attr_accessible :name, :number
  
  belongs_to :group
  
  mobile_regex = /\A(([0][7][5-9])(\d{8}))\Z/
  
  validates :name, :presence => true,
  :length => { :maximum => 15 }
  validates :number, :presence => true,
                     :format => { :with => mobile_regex },
                     :uniqueness => true
  
  
end
