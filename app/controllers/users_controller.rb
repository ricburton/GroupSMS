class UsersController < ApplicationController
  before_filter :authenticate, :only => [:index, :edit, :update, :destroy]
  before_filter :correct_user, :only => [:edit, :update, :destroy]
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

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])
    respond_to do |format|
      if @user.save
        flash[:success] = "Welcome to GroupTxt!"
        format.html { redirect_to(@user) }
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

  private

  def authenticate
    deny_access unless signed_in?
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end

  def is_admin?
    current_user.admin?
  end

end
