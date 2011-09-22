class Message < ActiveRecord::Base
   belongs_to :group

   def group_name
      Group.find(group_id).name
   end
end
