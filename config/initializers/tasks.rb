=begin
require 'rufus/scheduler'
require 'mediaburst'

@gateway = MediaBurst::API.new('burtonic', 'Test123') #todo put in a check for the connect and error-warning if connection doesn't work
@replies = @gateway.receive #todo store the latest replies in a DB so bad texts don't go o


scheduler = Rufus::Scheduler.start_new


scheduler.every("10s") do
prior_message_id = @replies.last.message_id


  last_number = @gateway.receive.last.from #ensure freshest message
  last_text = @gateway.receive.last.text
  last_sender_name = ""

  @users = User.all #collect all the user data
  all_numbers = Array.new

  #build an array of all the user's numbers on the DB
  @users.each do |user|
    number = user.number.sub( "0","44")
    all_numbers.push number
    if number == last_number
      last_sender_name = user.name
    end
  end
  
  p last_sender_name
  p last_text
  p last_number
    
  new_replies = @gateway.receive
  last_message_id = new_replies.last.message_id

  if @prior_message_id == last_message_id
    puts "No new messages to send"
  else
    #delete the number of the sender
    unique_numbers = all_numbers.delete_if { |x| x[last_number] }

    #loop through the hot numbers and send a text out to them.
    unique_numbers.each do |s| #s here is the next num to be sent to
      p last_sender_name + ": " + last_text + " will be sent to: " + s
      #@gateway.send last_sender_name + ": " + last_text, s
    end

    @prior_message_id = new_replies.last.message_id
    puts "Message needs to be sent from: #{last_number} saying: #{last_text}!"
  end
end
=end