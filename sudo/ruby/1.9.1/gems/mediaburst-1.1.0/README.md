# Mediaburst API Gem

The Mediaburst Gem is the fastest way of integrating the [Mediaburst API][2] into your own ruby applications.

## Installation

Install the gem as normal:

    sudo gem install mediaburst

The Mediaburst gem also relies on [Nokogiri][1] for XML parsing.

## Usage

Create an instance of the Mediaburst client:

    client = Mediaburst::API.new('username', 'password')

Send an SMS:

    response = client.send_message('441234567890', 'My test message')

Send a message to several numbers:

    response = client.send_message(['441234567890', '441234567891', '441234567892'], 'My test message')

Send a long message to several numbers using the [concat option][8]:

    options = {
      :concat => 3
    }
    
    response = client.send_message(['441234567890', '441234567891', '441234567892', '44'], SOME_LONG_MESSAGE, options)

Send a long message with a custom from address [from option][9]:

    options = {
      :concat => 3,
      :from => 'RubyDemo'
    }

    response = client.send_message(['441234567890', '441234567891', '441234567892', '44'], SOME_LONG_MESSAGE, options)

Check the response for errors:

    y response
    => ---
       "441234567890": true
       "441234567891": true
       "441234567892": true
       "44": 10

On error, the value of the key referenced by the number will equal the [error code][5] returned from Mediaburst.

### Checking the Account's Credit

Create an instance of the Mediaburst client:

    client = Mediaburst::API.new('username', 'password')

Request the credit amount

    client.get_credit
    => "150"

Given invalid credentials, this method will return nil. If the server responds with anything other than a 200, a Mediaburst::ServerError exception is raised.

## Development

The source for the gem is [hosted on GitHub][3] for you to peruse, fork and contribute to.

To enable us to easily manage your contributions, please submit your pull requests as single commits that include tests to show your changes working as normal. Please do not change the version number - we'll take care of that as we merge your changes.

## License

Copyright © 2011 [Matthew Hall][4], released under the ISC license. All trademarks and IP remain the property of their respective owners.


[1]:http://nokogiri.org/
[2]:http://www.mediaburst.co.uk/api
[3]:https://github.com/mediaburst/ruby-mediaburst-sms
[4]:http://codebeef.com/portfolio/mediaburst
[5]:http://www.mediaburst.co.uk/api/reference/error-codes/
[8]:http://www.mediaburst.co.uk/api/sending-a-message/parameters/#param-concat
[9]:http://www.mediaburst.co.uk/api/sending-a-message/parameters/#param-from
