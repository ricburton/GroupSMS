

class Group < ActiveRecord::Base

  has_many :memberships#, :foreign_key => "group_id"
                        #dependent => :destroy
  has_many :users, :through => :memberships #, :source => :joined
  has_many :users#, :class_name => User

  
  accepts_nested_attributes_for :users,
                                :reject_if => :all_blank
  #attr_accessible :user_attributes
  
  #attr_accessible :group_name, :name, :number, :password #, :user_number
  #attr_writer :group_name, :user_name, :user_number
  


  
  #def user_attributes=(user_attributes)
   # user_attributes.each do |attributes|
    #  users.build(attributes)
    #end
  #end
  
end
