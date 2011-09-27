class UsersController < ApplicationController
   before_filter :authenticate, :only => [:edit, :update, :destroy]
   #before_filter :correct_user, :only => [:edit, :update]
   before_filter :admin_user, :only => [:index]

   def addmember
      @user = User.new(params[:user])

      if @user.save
         sign_in @user
         format.html { redirect_to root_path }
         flash.now[:success] = "Welcome" #TODO add onboarding flash to new group
      else
         @title = "Sign up"
         format.html { render :action => "new" }
      end
   end


   def index
      @users = User.all
      respond_to do |format|
         format.html # index.html.erb
      end
   end

   def confirm
      @user = User.find(params[:id])
   end

   def show
      @user = User.find(params[:id])
      @title = @user.name
      @groups = Group.all
      @users = User.all
      @memberships = Membership.all
      @user_group_ids = Array.new

      @memberships.each do |m|
         if m.user_id == @user.id #change @users.first to current user
            @user_group_ids.push m.group_id
         end
      end

      @user_groups = Group.where(:id => @user_group_ids ).all.each

      #how to destroy group from user homepage... or perhaps after clicking on the group

      respond_to do |format|
         format.html # show.html.erb
      end
   end

   def new
      @title = "Join grouphug"
      @user = User.new
      @max_nums = Number.all.count

      if signed_in?
         if current_user.memberships.empty?
            logger.info("No memberships found and redirecting to new group path")
            redirect_to new_group_path
         else
            user_memberships = Array.new
            current_user.memberships.each {|mem| user_memberships.push mem.group_id}
            belonging_groups = Group.where(:id => user_memberships)
            redirect_to group_path(belonging_groups.first)
         end
      else
         respond_to do |format|
            format.html # new.html.erb
         end
      end 

   end

   def newadded
      logger.info("Newadded called")

      #todo - need to catch the user before the save action otherwise uniqueness condition is not satisfied
      @newuser = User.new(params[:user])

      @newuser.number.nil? ? test = "" : test = User.where(:number => @newuser.number)

      if test.blank?
         #already a non-registered member
         @newuser.toggle!(:registered)
      else
         if @newuser.memberships.count > 0
            user_group_ids = Array.new
            @newuser.memberships.each do |member|
               user_group_ids.push member.group_id
            end

            user_groups = Group.where(:id => user_group_ids).all.each

            user_groups.each do |group|
               p group.name
            end  
         else
            flash.now[:error] = "Caught a random occurrence with user saving."
            redirect_to root_path
         end
      end

      if @newuser.save
      else
         #todo redirection not working.
         flash.now[:error] = "Welcome"
         redirect_to root_path
      end
   end

   def edit
      @title = "Edit your account"
      @active_page = "EditUser"
      @user = User.find(params[:id])
   end

   def create
      @user = User.new(params[:user])
      logger.info("User creation")

      nexmo = Nexmo::Client.new('fd74a959', 'af3fc79f')
      nexmo.http.verify_mode = OpenSSL::SSL::VERIFY_NONE


      #establish whether the user is already in the system by their number
      user_check = User.where(:number => @user.number)
      existing_user = user_check.first
      #establish the source of the user-creation
      user_source = @user.signup_source.to_s

      if user_source.index("regform") == 0
         logger.info("regform")
         if user_check.count == 0
            logger.info("regform: New user")
            if @user.save
               logger.info("Save and sign-in new user")
               sign_in @user
               redirect_to new_group_path
               flash.now[:success] = "Welcome" #TODO add onboarding flash to new group
            else
               @title = "Sign up"
               render :action => "new"
            end
         elsif user_check.count >= 1
            logger.info("regform: Existing user")
            if existing_user.registered == true
               logger.info("regform:Registered user. Should not be signing up!")
               flash[:success] = "Please sign in. Have you forgotten your password?"
               redirect_to signin_path   
            else existing_user.registered == false #Non-registered user
               logger.info("regform:Non-registered user. Change details and sign in")
               existing_user.update_attributes(:registered => true, :name => @user.name, :password => @user.password)
               sign_in existing_user
               redirect_to root_path
            end
         else
            logger.error("Something weird is going on from the regform")
         end

      elsif user_source.index("addmember") == 0 #Source: add person. New group is dealt with at the group level to get the group id for memberships
         logger.info("addmember")

         #find the group_id of the user_creation
         scrub_addmember = user_source.gsub("addmember","")
         scrub_newgroup = scrub_addmember.gsub("newgroup","")
         group_id = scrub_newgroup.to_i
         group = Group.find(group_id)

         #TODO - assignment creation

         if user_check.count == 0 #TODO - error catching
            logger.info("addmember: New user")
            @user.save
            @user.memberships.create!(:group_id => group_id, :user_id => @user.id)
            #redirect_to root_path
            @user.assignments.create!(:user_id => @user.id, :number_id => Number.first.id, :group_id => group_id)
            user_id = @user.id.to_s

            #send welcome text



            #TODO how to get this recognize creator_name and group_name
            #          replacements = {
            #               "#{creator_name}" => creator_name,
            #               "#{group_name}" => group_name
            #            }

            #welcome_explanation = Notification.where(:purpose => "welcome_explanation").first.content.to_s

            #           replacements.each do |string, var|
            #              welcome_explanation.gsub!(string, var)
            #           end


            creator_name = User.find(group.creator_id).name
            group_name = group.name

            welcome_explanation = "#{creator_name} has added you to a GroupHug called #{group_name}. It's like chat over SMS where one text reaches all the members. Reply with '+join' to opt-in."

            @message = Message.new(:user_id => 1, :message => welcome_explanation, :group_id => group_id) #saves the admin message and prepends it with GroupHug  
            @message.save

            if Panel.first.sending == false #needs panel data present to function
               logger.info("SENDING OFF: welcome_explanation needs to be sent")
               logger.info(welcome_explanation.to_s)
            elsif Panel.first.sending == true #save this message in the message DB
               logger.info("Trying to send via Nexmo...")
               logger.info(user_id)
               user_id2 = @user.id.to_s
               logger.info(user_id2)
               response = nexmo.send_message({from: Number.find(Assignment.where(:user_id => @user.id, :group_id => group_id)), 
                  to: @user.number.to_s.insert(0, '44'), 
                  text: welcome_explanation})
                  redirect_to group
               end



               #redirect_to Group.find(group_id)
               redirect_to group
            elsif user_check.count >= 1
               logger.info("addmember: Existing user")

               #find all their existing number assignment id's
               user_number_ids = Array.new
               existing_user.assignments.each do |ass|
                  user_number_ids.push ass.number_id
               end

               if user_number_ids.count == Number.all.count
                  logger.error("Belongs to max number of groups already")
                  redirect_to(group, :notice => 'Sorry. That person already belongs to #{Number.all.count} groups.')
               else

                  #All number ids
                  all_number_ids = Array.new
                  @numbers.each do |number|
                     all_number_ids.push number.id
                  end

                  free_number_ids = all_number_ids - user_number_ids
                  first_free_num = free_number_ids.first

                  existing_user.memberships.create!(:user_id => user_check.id, :group_id => group_id)
                  existing_user.assignments.create!(:user_id => user_check.id, :number_id => first_free_num, :group_id => group_id)

                  creator_name = User.find(group.creator_id).name
                  group_name = group.name

                  welcome_explanation = "#{creator_name} has added you to a GroupHug called #{group_name}. It's like chat over SMS where one text reaches all the members. Reply with '+join' to opt-in."


                  @message = Message.new(:user_id => 1, :message => welcome_explanation, :group_id => group_id) #saves the admin message and prepends it with GroupHug  
                  @message.save

                  if Panel.first.sending == false #needs panel data present to function
                     logger.info("SENDING OFF: welcome_explanation needs to be sent")
                     logger.info(welcome_explanation.to_s)
                  elsif Panel.first.sending == true #save this message in the message DB
                     logger.info("Trying to send via Nexmo...")
                     response = nexmo.send_message({
                        from: Number.find(Assignment.where(
                        :user_id => @user.id,
                        :group_id => group_id).first.number_id).inbound_num, 
                        to: @user.number.to_s.insert(0, '44'), 
                        text: welcome_explanation})

                        redirect_to group
                     end


                     if existing_user.registered == true
                        flash.now[:success] = "New person added!"
                        #TODO why doesn't flash load?
                        logger.info("addmember:Registered user")

                        #SEND WELCOMENEWGROUP TEXT!
                     else user_check.registered == false #Non-registered user
                        flash.now[:success] = "New person added!"
                        logger.info("addmember:Non-registered user")
                        #SEND WELCOMEHALFINTRO TEXT!
                     end
                  end
               else
                  logger.error("Something weird is going on from the addmember")
               end

            else
               logger.info("new user trying to be created outside regform, addmember. It could be newgroup")

               @user.save

            end
         end

         def update
            @user = User.find(params[:id])
            respond_to do |format|
               if @user.update_attributes(params[:user])
                  flash[:success] = "Account details saved."
                  format.html { redirect_to(@user) }
               else
                  format.html { render :action => "edit" }
               end
            end
         end

         def destroy 
            @user = User.find(params[:id])
            @user.destroy
            respond_to do |format|
               format.html { redirect_to(@user) }
            end
         end

         private
         def authenticate 
            deny_access unless signed_in?
         end

         def correct_user 
            @user = User.find(params[:id])
            redirect_to root_path unless current_user?(@user)
         end

      end
