message = Message.new( :message => "blasshhh", :recipient => "447786201383" , :from => "7851864388")

@outbound_nums = Array.new

if message.message.index("+") == 0
  #add command set and actions in here
else
  #find corresponding group
  inbound_num_id = Number.where(:inbound_num => message.recipient).first.id
  if inbound_num_id.blank?
    puts "Unrecognized Inbound Number"
  else
    from_number_object = User.where(:number => message.from).first
    if from_number_object.blank?
      puts "Unrecognized Sender"
    else
      correct_group_id = Assignment.where(:number_id => inbound_num_id, :user_id => from_number_object.id).first.group_id
      if correct_group_id.blank?
        puts "No assigment found..."
      end
    end
  end

  if correct_group_id.blank?
    puts "No group ID found"
  else

    nexmo = Nexmo::Client.new('fd74a959', 'af3fc79f')
    nexmo.http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    outbound_memberships = Membership.where(:group_id => correct_group_id).all.each

    outbound_ids = Array.new #can this be refactored?
    outbound_memberships.each do |mem|
      outbound_ids.push mem.user_id
    end

    outbound_users = User.where(:id => outbound_ids).all.each

    #send the messages out
    outbound_users.each do |user|
      correct_assignment = Assignment.where(:user_id => user.id, :group_id => correct_group_id).first
      users_group_number = Number.find(correct_assignment.number_id)
      if user.number == message.from
        puts "Message isn't sent back to sender!"
      else
        puts "#{message.message} will be sent to #{user.number} from the number #{users_group_number.inbound_num}"
        
=begin      
    nexmo.send_message({from: users_group_number.inbound_num, to: user.number, text: message.message })


    response = nexmo.send_message({from: '447559600518',
      to: '447851864388', 
      text: 'Hi Father Ted'})
=end  
      end
    end
  end
end