class User < ActiveRecord::Base
  
  mobile_regex = /\A(([0][7][5-9])(\d{8}))\Z/
  
  validates :name, :presence => true,
  :length => { :maximum => 15 }
  validates :number, :presence => true,
  :format => { :with => mobile_regex }
  
  validates_uniqueness_of :number
  
  
end
