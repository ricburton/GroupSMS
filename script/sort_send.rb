=begin
def newpass( len )
chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
newpass = ""
1.upto(len) { |i| newpass << chars[rand(chars.size-1)] }
return newpass
end
=end
# nexmo = Nexmo::Client.new('fd74a959', 'af3fc79f')
# nexmo.http.verify_mode = OpenSSL::SSL::VERIFY_NONE
# response = nexmo.send_message({from: users_group_number.inbound_num, to: user.number, text: message.message })


#FIXME - is it worth creating my own sending function??? is that what the gem is for?
=begin
=end


#message = Message.new( :message => "+no", :recipient => "447786201383" , :from => "7851864388")
message = Message.new( :message => "helooooo guys it's windy!!!", :recipient => "447786201385" , :from => "7851864388")
#message = Message.new( :message => "+yes", :recipient => "447786201383" , :from => "7851864388")
#message = Message.new

#message = Message.new( :message => "+yes", :recipient => "447786201383" , :from => "78518")

#p message



if message.from.nil?
  p "nil user"
elsif User.where(:number => message.from).empty?
  p "no user match"
else
  inbound_num_id = Number.where(:inbound_num => message.recipient).first.id #don't need to check as it wont reach mediaburst
  if inbound_num_id.blank?
  p "No inbound num id found"
  end
  p "GROUP-NUMBER ID: #{inbound_num_id}"
  
  
  sending_user_id = User.where(:number => message.from).first.id
  if sending_user_id.blank?
    p "Not a grouphug user"
  end
  p "SENDING USER ID: #{sending_user_id}"
  
  
  
  check_assignment = Assignment.where(:number_id => inbound_num_id, :user_id => sending_user_id)
  if check_assignment.empty?
    p "No assignment match"
  end
  
  p "ASSIGNMENT ID: #{check_assignment.first.id}"
  p "CORRECT GROUP NAME: #{check_assignment.group_id}"
  


  if message.message.index("+") == 0
    #add command set and actions in here
    user_from_membership = Membership.where(:user_id => user_from.id, :group_id => correct_group_id).first

    if message.message.index("+yes") == 0 || message.message.index("+start") == 0
      puts "change them to active"

      user_from_membership.active = true
      p user_from_membership.active
      #TODO - dont toggle status set it to active
    end

    if message.message.index("+no") == 0 || message.message.index("+stop") == 0
      puts "change them to inactive"
      #TODO - dont toggle status set it to inactive
      user_from_membership.active = false
      p user_from_membership.active
    end

  else
    #find corresponding group

    message.save
    #TODO - how to turn this into a big method or readily accessible sending machine
    nexmo = Nexmo::Client.new('fd74a959', 'af3fc79f')
    nexmo.http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    outbound_memberships = Membership.where(:group_id => correct_group_id).all.each

    outbound_ids = Array.new #can this be refactored?
    outbound_memberships.each do |mem|
      outbound_ids.push mem.user_id
    end

    outbound_users = User.where(:id => outbound_ids).all.each


    outbound_users.each do |user|
      #send the messages out
      correct_assignment = Assignment.where(:user_id => user.id, :group_id => correct_group_id).first
      users_group_number = Number.find(correct_assignment.number_id)
      correct_recipient_user_membership = Membership.where(:user_id => user.id, :group_id => correct_group_id).first
      if user.number == message.from
        puts "Message isn't sent back to sender!"
        #put the message in a stamped envelope
        env = user.envelopes.create!(:user_id => user.id, :group_id => correct_group_id, :message_id => message.id)
        p env
      elsif correct_recipient_user_membership.active == false
        p "Message isn't sent to inactive users"
      else
        if Panel.first.sending == false
          p "SENDING OFF: #{message.message} will be sent to #{user.number} from the number #{users_group_number.inbound_num}"
        else
          response = nexmo.send_message({from: users_group_number.inbound_num, to: user.number, text: message.message })
        end
      end
    end
  end
end
