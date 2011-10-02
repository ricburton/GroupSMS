class GroupsController < ApplicationController
   before_filter :authenticate
   before_filter :admin_user, :only => [:index]
   #before_filter :authenticate, :only => [:edit, :update, :show, :destroy, :create]
   #before_filter :correct_user, :only => [:edit, :update]
   #before_filter :admin_user, :only => [:index, :destroy, :edit, :show]

   def index
      @groups = Group.all

      respond_to do |format|
         format.html
      end
   end

   def show
      @group = Group.find(params[:id])
      @user = User.new
      @message = Message.new
      @active_page = "UserHome"
      @max_nums = Number.all.count
      @used_nums = current_user.memberships.count

      #FIXME = why is cu_ass returning whoops?
      cu_ass = Assignment.where(:user_id => current_user.id, :group_id => @group.id).first
      cu_ass.nil? ? @cu_g_num = "Woops!" : @cu_g_num = "+44" + Number.find(cu_ass.number_id).inbound_num.to_s
      #@cu_g_num = "Woops!"
      
      #@cu_g_num = Number.find(cu_ass.number_id).inbound_num 

      if @used_nums >= @max_nums
         @hide_form = true
      end
      @group_messages = Message.order("created_at DESC").where(:group_id => @group.id)

      user_group_ids = Array.new    
      current_user.memberships.each do |cuser|
         user_group_ids.push cuser.group_id
      end
      @user_groups = Group.where(:id => user_group_ids ).all.each

      all_group_assignments = Assignment.where(:group_id => @group.id).all.each
      all_group_memberships = Membership.where(:group_id => @group.id).all.each

      group_user_ids = Array.new
      all_group_memberships.each do |membership|
         group_user_ids.push membership.user_id
      end

      user_number_ids = Array.new
      all_group_assignments.each do |ass|
         user_number_ids.push ass.number_id
      end

      @group_users = User.where(:id => group_user_ids ).all.each
      @user_numbers = Number.where(:id => user_number_ids).all.each
      respond_to do |format|
         format.html
      end


   end

   def new #FIXME it's possible to create more than 3 groups....
      @group = Group.new
      @max_nums = Number.all.count
      @used_nums = current_user.memberships.count
      if @used_nums >= @max_nums
         @hide_form = true
      end

      @group.users.build
   end

   def edit
      @group = Group.find(params[:id])
   end

   def create
      @group = Group.new(params[:group])
      @assignments = Assignment.all
      @numbers = Number.all

      @group.creator_id = current_user.id

      current_user_number_ids = Array.new #numbers the user has been assigned
      current_user.assignments.each do |cua|
         current_user_number_ids.push cua.number_id
      end

      all_number_ids = Array.new
      @numbers.each do |number|
         all_number_ids.push number.id
      end

      free_number_ids = all_number_ids - current_user_number_ids

      respond_to do |format|

         if @group.save



            ### creator-user attributes ###
            current_user.assignments.create!(:number_id => free_number_ids.first, 
            :user_id => current_user.id,
            :group_id => @group.id)

            current_user.memberships.create!(:user_id => current_user.id,
            :group_id => @group.id, :active => true)


            #current_user(:creator => true) #TODO - get this to work...

            ### member-user attributes ###
            member_number_ids = Array.new

            ### define info for the text ###
            creator_name = current_user.name
            group_name = @group.name
            welcome_explanation = "#{creator_name} has added you to a GroupHug called #{group_name}. It's like chat over SMS where one text reaches all the members. Reply with '+join' to opt-in."



            @group.users.each do |x|
               @group.memberships.create!(:active => false, :user_id => x.id, :group_id => @group.id)
               logger.info("New membership created")
               x.assignments.each do |ass|
                  member_number_ids.push ass.number_id
               end

               free_number_ids_for_member = all_number_ids - member_number_ids
               first_free_num_id = free_number_ids_for_member.first
               x.assignments.create!(:number_id => first_free_num_id, 
               :user_id => x.id, 
               :group_id => @group.id)   


               #SEND WELCOME MESSAGES HERE!!!
               if Panel.first.sending == false #needs panel data present to function
                  logger.info("SENDING OFF: welcome_explanation needs to be sent")
                  logger.info(welcome_explanation.to_s)
               elsif Panel.first.sending == true #save this message in the message DB

                  @nexmo = Nexmo::Client.new('fe5bb9db', '4589a092')
                  @nexmo.http.verify_mode = OpenSSL::SSL::VERIFY_NONE


                  from_number = "44" + Number.find(first_free_num_id).inbound_num.to_s
                  correct_num = "44" + x.number.to_s

                  response = @nexmo.send_message({from: from_number, 
                     to: correct_num, 
                     text: welcome_explanation})

                     logger.info(response)

                  end
               end

               format.html { redirect_to(@group, :notice => 'Your GroupHug is now live. People just have to opt-in to start receiving messages.') }
               #TODO - how to get this to fade.

            else
               format.html { render :action => "new" }
            end
         end
      end

      #logger.info @group.users
      #logger.info params[:group][:users_attributes]

      #@user = User.new



      def update
         @group = Group.find(params[:id])

         respond_to do |format|
            if @group.update_attributes(params[:group])
               format.html { redirect_to(@group, :notice => 'Group was successfully updated.') }
            else
               format.html { render :action => "edit" }
            end
         end
      end

      def destroy
         @group = Group.find(params[:id])
         @group.destroy

         respond_to do |format|
            format.html { redirect_to root_path }
         end
      end
   end
