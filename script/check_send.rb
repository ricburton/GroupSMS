#TEST MESSAGE
message = Message.new( :message => "helooooo guys it's windy!!!",
:recipient => "447786201383" , 
:from => "7851864388")

#DATA CHECKING

group_num = Number.where(:inbound_num => message.recipient).first
sending_user = User.where(:number => message.from).first
if group_num.blank? || sending_user.blank?
   p "Group or user number not recognised"
else
   check_ass = Assignment.where(:number_id => group_num.id, 
   :user_id => sending_user.id).first
   if check_ass.blank?
      p "No assignment found"
   else
      p "Correct group name: #{Group.find(check_ass.group_id).name}"
      correct_group_id = check_ass.group_id
      user_from_membership = Membership.where(:group_id => correct_group_id,
      :user_id => sending_user.id).first
      if user_from_membership.blank?
         p "Not a member"
      else
         p "Is a member"

         #COMMANDS

         if message.message.index("+") == 0
            if message.message.index("+yes") == 0 || message.message.index("+start") == 0
               puts "change them to active"

               user_from_membership.active = true
               p user_from_membership.active
            end

            if message.message.index("+no") == 0 || message.message.index("+stop") == 0
               puts "change them to inactive"
               user_from_membership.active = false
               p user_from_membership.active
            end
         else
            p "It's not a command"

            message.group_id = correct_group_id
            message.save

            p "Message for #{Group.find(message.group_id).name}"

            #SENDING CHECKS
            nexmo = Nexmo::Client.new('fd74a959', 'af3fc79f')
            nexmo.http.verify_mode = OpenSSL::SSL::VERIFY_NONE

            outbound_memberships = Membership.where(:group_id => correct_group_id).all.each
            if outbound_memberships.blank?
               p "There are no members"
            else
               p "There are members"
               outbound_user_ids = Array.new #can this be refactored?
               outbound_memberships.each do |mem|
                  outbound_user_ids.push mem.user_id unless mem.user_id == sending_user.id #don't send to self
               end

               outbound_users = User.where(:id => outbound_user_ids).all.each
               outbound_users.each do |user|
                  #send the messages out
                  correct_assignment = Assignment.where(:user_id => user.id,
                  :group_id => correct_group_id).first

                  if correct_assignment.blank?
                     p "No assignment for this user"
                  else
                     p "Assignment found for this user called #{user.name}"
                     #SENDING ACTION

                     cu_membership = Membership.where(:user_id => user.id, 
                     :group_id => correct_group_id).first


                     if cu_membership.active == false
                        p "Don't send to inactive users"
                     elsif Panel.first.sending == false
                        p "SENDING IS OFF"
                     else
                        response = nexmo.send_message({from: users_group_number.inbound_num, to: user.number, text: message.message})
                     end
                  end
               end
            end
         end
      end
   end
end



