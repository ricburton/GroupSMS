
@group = Group.first

group_envelopes = Envelope.where(:group_id => @group.id).all.each

group_message_ids = Array.new
group_envelopes.each do |env|
  group_message_ids.push env.message_id
end

@group_messages = Message.order("created_at DESC").where(:id => group_message_ids).all.each

puts @group_messages

@group_messages.each do |message|
  p message.message
  p message.from
  p message.origin
  p message.created_at
end