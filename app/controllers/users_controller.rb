class UsersController < ApplicationController
  before_filter :authenticate, :only => [:edit, :update, :destroy]
  #before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user, :only => [:index]

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
    #logger.info("Newadded called")

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

  def create #TODO - figure out how fields_for functions
    @user = User.new(params[:user])
    logger.info("User creation")
    respond_to do |format|
      if @user.save
        sign_in @user
        format.html { redirect_to new_group_path }
        flash.now[:success] = "Welcome" #TODO add onboarding flash to new group
      else
        @title = "Sign up"
        format.html { render :action => "new" }
      end
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

end
