#todo - get request from callback url to ruby
require 'rubygems'
require 'nexmo'

nexmo = Nexmo::Client.new('fd74a959', 'af3fc79f')

nexmo.http.verify_mode = OpenSSL::SSL::VERIFY_NONE

response = nexmo.send_message({ 
  from: 'RUBY',
  to: '447851864388', 
  text: 'Hello world'})

  if response.failure?
    raise response.error
  elsif response.success?
    puts "Sent a message!"
  end

