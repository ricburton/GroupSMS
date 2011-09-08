class Assignment < ActiveRecord::Base
  belongs_to :numbers, :dependent => :destroy
  belongs_to :users, :dependent => :destroy
  #validates_uniqueness_of :reader_id, :scope => :blog_id
end
