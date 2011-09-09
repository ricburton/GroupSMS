class UsersController < ApplicationController
  before_filter :authenticate, :only => [:index, :edit, :update, :destroy]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user, :only => [:destroy]

  def index
    @users = User.all
    respond_to do |format|
      format.html # index.html.erb
    end
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
    @title = "Join GroupTxt"
    @user = User.new

    if signed_in?
      if current_user.memberships == 0
        redirect_to new_group_path
      else
        cugroup = current_user.memberships.first.group_id
        redirect_to group_path(cugroup)
      end
    else
      respond_to do |format|
        format.html # new.html.erb
      end
    end




  end

  def edit
    @title = "Edit your account"
    @active_page = "EditUser"
  end

  def create
    @user = User.new(params[:user])

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
