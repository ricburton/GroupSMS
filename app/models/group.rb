# == Schema Information
# Schema version: 20110826221216
#
# Table name: groups
#
#  id         :integer         not null, primary key
#  group_name :string(255)
#  created_at :datetime
#  updated_at :datetime
#

 # accepts_nested_attributes_for :user
 
 #todo - understand how to build Users as group submits....
 
 #def users
  # @users = User.all #why is this causing the view to render three new user submits
 #end
 

class Group < ActiveRecord::Base
  has_many :memberships#, :foreign_key => "group_id"
                        #dependent => :destroy
  has_many :users, :through => :memberships #, :source => :joined
  
  accepts_nested_attributes_for :users  
  
  attr_accessible :group_name, :name, :number, :password #, :user_number
  #attr_writer :group_name, :user_name, :user_number
  


  
  #def user_attributes=(user_attributes)
   # user_attributes.each do |attributes|
    #  users.build(attributes)
    #end
  #end
  
end
