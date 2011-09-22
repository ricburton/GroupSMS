class Assignment < ActiveRecord::Base
  belongs_to :numbers, :dependent => :destroy
  belongs_to :users, :dependent => :destroy
  
  belongs_to :groups
  #validates_uniqueness_of :reader_id, :scope => :blog_id
  
  def inbound_num
     number_id.nil? ? "fucked" : Number.find(number_id).inbound_num
  end
  
  def group_name
     group_id.nil? ? "fucked" : Group.find(group_id).name
  end
  
  def user_name
     user_id.nil? ? "fucked" : User.find(user_id).name
  end
  
end
