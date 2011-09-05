class Membership < ActiveRecord::Base
  belongs_to :groups, :dependent => :destroy
  belongs_to :users, :dependent => :destroy
end
