class ApplicationController < ActionController::Base
  #before_filter :authenticate, :only => [:edit, :update, :destroy]



  def deny_access
    #store_location #this will store where the user is trying to get to and then redirect after sign in
    redirect_to signin_path, :notice => "Please sign in to access this page."
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default) #not sure what this does
    clear_return_to #what's this going to do
  end

  protect_from_forgery
  include SessionsHelper

  private

  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end
  
  def authenticate
    deny_access unless signed_in?
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end

  def authenticate
    deny_access unless signed_in? #deny access method will be defined in SessionsHelper
  end
end
