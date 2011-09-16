  def newpass( len )
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    newpass = ""
    1.upto(len) { |i| newpass << chars[rand(chars.size-1)] }
    return newpass
  end
  
  # nexmo = Nexmo::Client.new('fd74a959', 'af3fc79f')
  # nexmo.http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  # response = nexmo.send_message({from: users_group_number.inbound_num, to: user.number, text: message.message })
  
  
  #FIXME - is it worth creating my own sending function??? is that what the gem is for?
=begin
  def sendtext( from, to, text )
    nexmo = Nexmo::Client.new('fd74a959', 'af3fc79f')
    nexmo.http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    response = nexmo.send_message({from: users_group_number.inbound_num, to: user.number, text: message.message })
  end
=end


message = Message.new( :message => "+no", :recipient => "447786201383" , :from => "7851864388")
#message = Message.new( :message => "+yes", :recipient => "447786201383" , :from => "7851864388")
#message = Message.new

#message = Message.new( :message => "+yes", :recipient => "447786201383" , :from => "78518")

p message

@outbound_nums = Array.new


if message.from.nil?
  p "nil user"
  #logger.info("nil user") #todo logger?
elsif User.where(:number => message.from).empty?
  p "no user match"
  #logger.info("no user")
else
  #get the data about which group this is sent to
  
  @inbound_num_id = Number.where(:inbound_num => message.recipient).first.id
  user_from = User.find(@inbound_num_id)
  correct_group_id = Assignment.where(:number_id => @inbound_num_id, :user_id => user_from.id).first.group_id
  if correct_group_id.blank?
    puts "No assignment found..."
  end
  
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
        puts "#{message.message} will be sent to #{user.number} from the number #{users_group_number.inbound_num}"
        # response = nexmo.send_message({from: users_group_number.inbound_num, to: user.number, text: message.message })
      end
    end
  end
end
