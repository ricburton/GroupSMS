#def create
#regform #is a non-reg user     ----> UPDATE DETAILS(name,registered) ---> ROOT_PATH(existing groups)
#is a reg user         ----> SIGN_IN_PATH
#is not a user         ----> CREATE DETAILS ---> NEW_GROUP_PATH

#addmember #is a non-reg user ----> CREATE MEMBERSHIP             --|
#CREATE ASSIGNMENT
#SEND WELCOMETOGROUP
#is a reg user     ----> CREATE MEMBERSHIP             --> CORRECT_GROUP for mother-user
#CREATE ASSIGNMENT
#SEND WELCOMETOGROUP
#is not a user     ----> CREATE DETAILS                --|
#CREATE MEMBERSHIP
#CREATE ASSIGNMENT
#SEND WELCOME

#comment for testing
#@user = User.new(params[:user])


#TEST DATA
@user = User.new(:signup_source => "reform", :number => "07851864388", :registered => false)

logger.info("User creation")


#establish whether the user is already in the system by their number
user_check = User.where(:number => @user.number)

#establish the source of the user-creation
user_source = @user.signup_source.to_s

if user_source.index("regform") == 0
   logger.info("regform")
   if user_check.count == 0
      logger.info("regform: New user")
      if @user.save
         logger.info("Save and sign-in new user")
         sign_in @user
         format.html { redirect_to new_group_path }
         flash.now[:success] = "Welcome" #TODO add onboarding flash to new group
      else
         @title = "Sign up"
         format.html { render :action => "new" }
      end
   elsif user_check.count >= 1
      logger.info("regform: Existing user")
      if user_check.registered == true
         logger.info("regform:Registered user. Should not be signing up!")
         flash[:succes] = "Please sign in. Have you forgotten your password?"
         redirect_to signin_path   
      else user_check.registered == false #Non-registered user
         logger.info("regform:Non-registered user. Change details and sign in")
         user_check.first.toggle!(:registered)
         user_check.first.name = @user.name
         user_check.first.password = @user.password
         sign_in user_check.first
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

   #TODO - assignment creation

   user_number_ids = Array.new
   user_check.assignments.each do |ass|
      user_number_ids.push ass.number_id
   end

   if user_number_ids.count == Number.all.count
      flash.now[:error] = "Sorry this person belongs to #{Number.all.count} groups" 
      redirect_to root_path
   else
      #All number ids
      all_number_ids = Array.new
      @numbers.each do |number|
         all_number_ids.push number.id
      end

      free_number_ids = all_number_ids - user_number_ids
      first_free_num = free_number_ids.first

      if user_check.count == 0
         logger.info("addmember: New user")
         @user.save
         @user.memberships.create!(:group_id => group_id, :user_id => @user.id)
         #redirect_to root_path
         @user.assignments.create!(:user_id => @user.id, :number_id => first_free_num)
         #SEND WELCOME TEXT!
         redirect_to Group.find(group_id)
      elsif user_check.count >= 1
         logger.info("addmember: Existing user")
         if user_check.registered == true
            logger.info("addmember:Registered user")
            user_check.memberships.create!(:user_id => user_check.id, :group_id => group_id)
            user_check.assignments.create!(:user_id => user_check.id, :number_id => first_free_num)
            #SEND WELCOME TEXT!
         else user_check.registered == false #Non-registered user
            logger.info("addmember:Non-registered user")
            user_check.memberships.create!(:user_id => user_check.id, :group_id => group_id)
            user_check.assignments.create!(:user_id => user_check.id, :number_id => first_free_num)
            #SEND WELCOME TEXT!
         end
      else
         logger.error("Something weird is going on from the addmember")
      end
   end

else
   logger.info("new user trying to be created outside regform, addmember. It could be newgroup")

   @user.save

end




#SORT ERROR HANDLING!!!

user_check = User.where(:number => @user.number)
if user_check.count == 0
   if @user.signup_source.to_s.index("addmember") == 0
      #save the user and build the membership if being added by group
      @user.save
      group_id = @user.signup_source.gsub!("addmember","").to_i
      @user.memberships.create(:group_id => group_id, :user_id => @user.id)
      redirect_to root_path #CHANGE THIS!
   else
      logger.info("User not found in DB")
      respond_to do |format|
         if @user.save
            logger.info("Save and sign-in user")
            sign_in @user
            format.html { redirect_to new_group_path }
            flash.now[:success] = "Welcome" #TODO add onboarding flash to new group
         else
            @title = "Sign up"
            format.html { render :action => "new" }
         end
      end
   end

elsif user_check.count >= 1 && user_check.first.registered == false

   if @user.signup_source.to_s.index("addmember") == 0
      #build the membership if being added from group
      group_id = @user.signup_source.gsub!("addmember","").to_i
      user_check.memberships.create!(:user_id => user_check.id, :group_id => group_id)
   elsif
      logger.info("User found in DB")
      user_check.first.toggle!(:registered)
      user_check.first.name = @user.name
      user_check.first.password = @user.password
      sign_in user_check.first
      redirect_to root_path
   else
      logger.info("User not there")
      user_check.blank? == false && @user.registered == true
      flash[:succes] = "Please sign in. Have you forgotten your password?"
      redirect_to signin_path   
   end

elsif user_check.count >= 1 && user_check.first.registered == true

end
end
