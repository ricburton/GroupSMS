class MessagesController < ApplicationController
  before_filter :authenticate
  def index
    @messages = Message.all #todo change to only user's messages

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

  def external_message
    @message.text = params[:message]
    @message.recipient = params[:to]
    @message.api_message_id = params[:messageId]
  end

  def nexmo_create
    @message = Message.new(:message => params[:message],
                           :recipient => params[:to], 
                           :api_message_id => params[:messageId], 
                           :from => params[:from])
    @message.save
  end

  #http://smsgroup.heroku.com/mediaburst_create

  def mediaburst_create
    @message = Message.new(:message => params[:PAYLOAD], 
                           :recipient => params[:DEST_ADDR], 
                           :api_message_id => params[:MSG_ID], 
                           :from => params[:SRC_ADDR], 
                           :api_timestamp => params[:DATETIME], 
                           :network => params[:NETWORK])
    @message.save
  end

  def edit
    @message = Message.find(params[:id])
  end

  def create
    @message = Message.new(params[:message])

    respond_to do |format|
      if @message.save
        format.html { redirect_to(@message, :notice => 'Message was successfully created.') }
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
