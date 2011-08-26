#class SendTexts < ActiveRecord::Base

require 'textmagic'

gateway = TextMagic::API.new('burtonic', '3AeMiofRgXOFQJT')
replies = gateway.receive
last_number = replies.last.from
last_text = replies.last.text
last_sender_name = ""



all_numbers = Array.new

#build an array of all the numbers
@users.each do |user|
  number = user.number.sub( "0","44")
  all_numbers.push number
  if number == last_number
    last_sender_name = user.name
  end
end

#delete the number of the sender
unique_numbers = all_numbers.delete_if { |x| x[last_number] }

#loop through the hot numbers and send a text out to them.
unique_numbers.each do |s| #s here is the next num to be sent to
  p last_sender_name + ": " + last_text + " will be sent to: " + s
  gateway.send last_sender_name + ": " + last_text, s
end


#need to use sent_text to stop duplicates being sent out.





#testbox
#p last_number
#p last_text
#p last_sender_name
#p unique_numbers

=begin  
count = 0
# find the last name
@users.each do |user|
count += 1
number = last_number.sub( "44","0")
if number == user.number
last_sender_name = user.name
else
last_sender_name = "No match" #between number and name
p number + user.number
#p @users
end
end
puts count
#initiate the sending of the texts to all the users
unique_numbers.each do |s| #s here is the next num to be sent to
p last_sender_name + ": " + last_text + " will be sent to: " + s
#gateway.send last_sender_name + ": " + last_text, s
end
=end  
#end

=begin

@users.each do |u|
format_number = u.number.sub( "0","44")
p last_number + format_number
if last_number == format_number
#@users
p "match"
# @users.each do |send|
#p u.name + ": " + last_text + " to " + format_number
#gateway.send u.name + ": " + last_text, format_number
# end
else
p "no match" 
end
end


replies.each do |t|
if t.from == num1
puts t.text
else
puts 'no match'
end
end


replies.each do |t|
if t.from == last_number
puts 'send: ' + t.text + ' to ' + num2 + ' and ' + num3
else
puts 'dont send'
end
end

end




if last_number == num1
gateway.send 'Richard:' + last_text, num2, num3
elsif last_number == num2
gateway.send 'Tom: ' + last_text, num1, num3
else last_number == num3
gateway.send 'Mum: ' + last_text, num1, num2
end



num1 = '447851864388'
num2 = '447590311499'
num3 = '447740842460'

'447740842460' mum

puts "What's your mobile number?: "

#num = gets


=end


#replies = gateway.receive
#puts "All the replies: " + replies.to_s
#
#
#puts "last person to text: " + last_number.to_s
#
#last_message_id = replies.last.message_id
#puts "Last message's ID: " + last_message_id.to_s
#

#gateway.send 'Hello World!', '447851864388'

#p gateway.account.balance
#gateway.send 'This message goes to multiple people', '447851864388', '447851864388', '447851864388'

#gateway.send 'Hello this is a really long messsage and it is being split', '447851864388', max_length => 2

#gateway.send 'Two hours later', '447851864388', :send_time = Time.now.to_i + 7200

#checking send status

#gateway.send('Test message','447851864388')

# Will return => '141421'
#status = api.message_status('141421')

#will return => 'd' for delivered!

#status.completed_time

#will give us a datetime return

# several responses....
#api.send('Hi Wilma!', '999314159265', '999271828182').message_id
## => { '999314159265' => '141421', '999271828182' => '173205' }
#statuses = api.message_status('141421', '173205')
## => { '141421' => 'r', '173205' => 'd' }
#statuses['173205'].created_time
## => Thu May 28 16:41:45 +0200 2009



