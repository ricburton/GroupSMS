client = Mediaburst::API.new( 'burtonic@gmail.com', 'This123')

response = client.send_message('447851864388', 'Hello Richard')

puts response