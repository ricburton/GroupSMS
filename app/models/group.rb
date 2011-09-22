class Group < ActiveRecord::Base

  has_many :memberships#, :foreign_key => "group_id"
                        #dependent => :destroy
  has_many :users, :through => :memberships #, :source => :joined
  has_many :users#, :class_name => User

  
  accepts_nested_attributes_for :users,
                                :reject_if => :all_blank
  
  has_many :assignments
  accepts_nested_attributes_for :assignments
  
  has_many :messages
                                
  before_destroy { |group| 
    group.memberships.destroy_all
    group.assignments.destroy_all
    }
    
    
  validates :name, :presence => true, #todo regexp for first name only
  :length => { :maximum => 15 }
 
  def creator_name
     creator_id.nil? ? "fucked" : User.find(creator_id).name
  end
  
  
  
  #todo - strip out random characters
  
  
  #attr_accessible :user_attributes
  
  #attr_accessible :name, :name, :number, :password #, :user_number
  #attr_writer :name, :user_name, :user_number
  


  
  #def user_attributes=(user_attributes)
   # user_attributes.each do |attributes|
    #  users.build(attributes)
    #end
  #end
  
end
