class Membership < ActiveRecord::Base
  belongs_to :groups, :dependent => :destroy
  belongs_to :users, :dependent => :destroy
  before_destroy { |membership|
    Assignment.where(:user_id => membership.user_id).destroy_all
  }
end
