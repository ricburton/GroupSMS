class MessagesController < ApplicationController
  before_filter :authenticate, :only => [:show]
  before_filter :admin_user, :only => [:index]

=begin
  def sendtext( from, to, text )
    if Panel.first.sending = true
      nexmo = Nexmo::Client.new('fd74a959', 'af3fc79f')
      nexmo.http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      response = nexmo.send_message({from: from, to: to, text: text })
    else
      logger.info("A text would have been sent.")
    end
  end
=end
  def index
    @messages = Message.all

    respond_to do |format|
      format.html
    end
  end

  def show
    @message = Message.find(params[:id])

    respond_to do |format|
      format.html
    end
  end

  def new
    @message = Message.new

    respond_to do |format|
      format.html
    end
  end

  def mediaburst_create
    message = Message.new( :message => params[:PAYLOAD], 
    :recipient => params[:DEST_ADDR], 
    :api_message_id => params[:MSG_ID], 
    :from => params[:SRC_ADDR], 
    :api_timestamp => params[:DATETIME], 
    :network => params[:NETWORK],
    :origin => "sms")

    message.save
    redirect_to message
  end

  def edit
    @message = Message.find(params[:id])
  end

  def create
    @message = Message.new(params[:message])
    #envelopes replace with message.group_id
    respond_to do |format|
      if @message.save
         

        sendtext( 447851864388, 90909123049120, "boooasdfaklsjdklfjklj" )


        format.html { redirect_to group_path(@message.group_id), :notice => 'Message was sent.' } #
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @message = Message.find(params[:id])

    respond_to do |format|
      if @message.update_attributes(params[:message])
        format.html { redirect_to(@message, :notice => 'Message was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @message = Message.find(params[:id])
    @message.destroy

    respond_to do |format|
      format.html { redirect_to(messages_url) }
    end
  end
end
