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

   #DATA CHECKING
   
   stripped_recip = message.recipient.slice(0..1) #strip
   stripped_from = message.from.slick(0..1) #strip
   
   logger.info(stripped_recip)
   logger.info(stripped_from)

   group_num = Number.where(:inbound_num => stripped_recip).first
   sending_user = User.where(:number => stripped_from).first
   if group_num.blank? || sending_user.blank?
      logger.info("Group or user number not recognised")
   else
      check_ass = Assignment.where(:number_id => group_num.id, 
      :user_id => sending_user.id).first
      if check_ass.blank?
         logger.info("No assignment found")
      else
         logger.info("Correct group name: #{Group.find(check_ass.group_id).name}")
         correct_group_id = check_ass.group_id
         user_from_membership = Membership.where(:group_id => correct_group_id,
         :user_id => sending_user.id).first
         if user_from_membership.blank?
            logger.info("Not a member")
         else
            logger.info("Is a member")

            #COMMANDS

            if message.message.index("+") == 0
               if message.message.index("+yes") == 0 || message.message.index("+start") == 0
                  logger.info("change them to active")

                  user_from_membership.active = true
                  
               end

               if message.message.index("+no") == 0 || message.message.index("+stop") == 0
                  logger.info("change them to inactive")
                  user_from_membership.active = false
               end
            else
               logger.info("It's not a command")

               message.group_id = correct_group_id
               message.save

               logger.info("Message for #{Group.find(message.group_id).name}")

               #SENDING CHECKS
               nexmo = Nexmo::Client.new('fd74a959', 'af3fc79f')
               nexmo.http.verify_mode = OpenSSL::SSL::VERIFY_NONE
               
               formatted_message = sending_user.name + ": " + message.message

               outbound_memberships = Membership.where(:group_id => correct_group_id).all.each
               if outbound_memberships.blank?
                  logger.info("There are no members")
               else
                  logger.info("There are members")
                  outbound_user_ids = Array.new #can this be refactored?
                  outbound_memberships.each do |mem|
                     outbound_user_ids.push mem.user_id unless mem.user_id == sending_user.id #don't send to self
                  end

                  outbound_users = User.where(:id => outbound_user_ids).all.each
                  outbound_users.each do |user|
                     #send the messages out
                     correct_assignment = Assignment.where(:user_id => user.id,
                     :group_id => correct_group_id).first
                     users_group_number = Number.find(correct_assignment.number_id)
                     
                     
                     
                     if correct_assignment.blank?
                        logger.info("No assignment for this user")
                     else
                        logger.info("Assignment found for this user called #{user.name}")
                        #SENDING ACTION

                        cu_membership = Membership.where(:user_id => user.id, 
                        :group_id => correct_group_id).first


                        if cu_membership.active == false
                           logger.info("Don't send to inactive users")
                        elsif Panel.first.sending == false #needs panel data
                           logger.info("SENDING IS OFF")
                        else
                           logger.info("Trying to send via Nexmo...")
                           response = nexmo.send_message({from: users_group_number, to: user.number, text: formatted_message})
                        end
                     end
                  end
               end
            end
         end
      end
   end
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


         # sendtext( 447851864388, 90909123049120, "boooasdfaklsjdklfjklj" )


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
