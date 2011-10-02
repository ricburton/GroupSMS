class Membership < ActiveRecord::Base
   belongs_to :groups, :dependent => :destroy
   belongs_to :users, :dependent => :destroy
   before_destroy { |membership|
      Assignment.where(:user_id => membership.user_id).destroy_all
   }

   def group_name
      group_id.nil? ? "fucked" : Group.find(group_id).name
   end

   def user_name
      user_id.nil? ? "fucked" : User.find(user_id).name
   end



end
