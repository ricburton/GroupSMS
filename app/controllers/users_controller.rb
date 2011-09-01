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


    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def new
    @title = "Join GroupTxt"
    @user = User.new
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def edit
    @title = "Edit your account"
  end

  def create
    @user = User.new(params[:user])
    respond_to do |format|
      if @user.save
        flash[:success] = "Welcome to GroupTxt!"
        format.html { redirect_to(new_group_path) }
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
