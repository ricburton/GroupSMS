require 'nokogiri'
require 'net/http'

module Mediaburst
  SEND_ENDPOINT = 'http://sms.message-platform.com/xml/send.aspx'
  CREDIT_ENDPOINT = 'http://sms.message-platform.com/http/credit.aspx'
  
  # Thrown when an invalid request is made, 
  # e.g invalid credentials were used
  class InvalidRequest < Exception
  end

  # Thrown when we don't get a succesful response 
  # from the mediaburst server
  class ServerError < Exception
  end
  
  class API
    def initialize(u, p)
      @auth = {:username => u, :password => p}
    end
    
    
    # Returns the about of credit left on a user account
    #
    # nil if there was a problem retrieving the value, and
    # Throws an exception if the server didn't process 
    # the request succesfully.
    def get_credit
      uri = URI.parse(CREDIT_ENDPOINT + "?username=#{@auth[:username]}&password=#{@auth[:password]}")
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Get.new(uri.request_uri)
      request["Content-Type"] = "text/html"

      response = http.request(request)
      
      case response
      when Net::HTTPSuccess
        return response.body.gsub!(/^Current Credit: ([0-9]+)/, '\1')
      else
        raise Mediaburst::ServerError, "Request failed: #{response}"
      end
    end
  
    # Takes a number or array of numbers and a content string
    # and sends to the mediaburst SMS API endpoint.
    #
    # numbers - a string or array of strings 
    # content - the string to send
    # options - a hash of options to send to the API
    #
    # Returns a hash in the format:
    # "phone number" => true on success or an error number on failure
    def send_message(numbers, content, options ={})
      numbers = [numbers] unless numbers.class == Array
      self.process_response(self.send_request(self.create_xml(numbers, content, options)))
    end
  
    # Get the xml for the request
    def create_xml(numbers, content, options)
      # Note that the username and password should be the first elements passed
      builder = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
        xml.message {
          xml.Username @auth[:username]
          xml.Password @auth[:password]
          
          numbers.each do |number|
            xml.SMS {
              xml.To number
              xml.Content content
              options.each do |k, v|
                xml.send(k.to_s, v)
              end
            }
          end
        }
      end
      
      builder.to_xml
    end
    
    # Send a request to the endpoint
    def send_request(request_body)
      # Create and send the request
      uri = URI.parse(SEND_ENDPOINT)
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Post.new(uri.request_uri)
      request.body = request_body
      request["Content-Type"] = "text/xml"

      http.request(request)
    end
    
    # Process the received response
    def process_response(response)
      # Make sure we get a successful response
      case response
      when Net::HTTPSuccess
        # Parse the response
        response_xml = Nokogiri::XML(response.body)
      
        if response_xml.xpath('//SMS_Resp').empty?
          raise Mediaburst::InvalidRequest, "ERROR: #{response_xml.xpath('//ErrDesc').inner_text}"
        else
          responses = {}
          response_xml.xpath('//SMS_Resp').each do |sms_resp|
            if sms_resp.xpath('ErrDesc').empty?
              responses[sms_resp.xpath('To').inner_text] = true
            else
              responses[sms_resp.xpath('To').inner_text] = sms_resp.xpath('ErrNo').inner_text.to_i
            end
          end
        end
      else
        raise Mediaburst::ServerError, "Request failed: #{response}"
      end
    
      responses
    end
  end
end
