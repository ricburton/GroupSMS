class Assignment < ActiveRecord::Base
  belongs_to :numbers, :dependent => :destroy
  belongs_to :users, :dependent => :destroy
  
  belongs_to :groups
  #validates_uniqueness_of :reader_id, :scope => :blog_id
end
