class MessagesController < ApplicationController
  #before_filter :authenticate
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

  def mediaburst_create
    message = Message.new( :message => params[:PAYLOAD], 
                           :recipient => params[:DEST_ADDR], 
                           :api_message_id => params[:MSG_ID], 
                           :from => params[:SRC_ADDR], 
                           :api_timestamp => params[:DATETIME], 
                           :network => params[:NETWORK],
                           :origin => "sms")
=begin    
    @outbound_nums = Array.new
          
    if message.message.index("+") == 0
      #add command set and actions in here
    else
      #find corresponding group
      inbound_num_id = Number.id.where(:inbound_num => message.recipient)
      from_number_id = User.id.where(:number => message.from)
      @correct_group_id = Assignment.where(:number_id => inbound_num_id, :user_id => from_number_id).all.each
      
    end
=end    
    message.save
    redirect_to message
  end

  def edit
    @message = Message.find(params[:id])
  end

  def create
    @message = Message.new(params[:message])
                           
    respond_to do |format|
      if @message.save
        current_user.envelopes.create!(:user_id => current_user.id, :group_id => @message.group_id, :message_id => @message.id)
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
