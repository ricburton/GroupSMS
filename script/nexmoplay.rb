#todo - get request from callback url to ruby

nexmo = Nexmo::Client.new('fe5bb9db', '4589a092')

nexmo.http.verify_mode = OpenSSL::SSL::VERIFY_NONE

response = nexmo.send_message({from: '447917793752',
                               to: '447533737279', 
                               text: ''})

  if response.failure?
    raise response.error
  elsif response.success?
    puts "Sent a message!"
  end

puts response

#puts incoming
