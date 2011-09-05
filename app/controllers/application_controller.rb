class ApplicationController < ActionController::Base
  before_filter :authenticate, :only => [:edit, :update, :destroy]
  
  #todo - add title as person's name
  
  protect_from_forgery
  include SessionsHelper
  
  private
  
  def authenticate
    deny_access unless signed_in? #deny access method will be defined in SessionsHelper
  end
end
