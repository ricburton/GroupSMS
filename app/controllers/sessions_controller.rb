class SessionsController < ApplicationController


  def new
    @title = "Sign in"
  end

  def create #todo when signing up the person isn't signing in...
    user = User.authenticate(params[:session][:number],params[:session][:password])
    if user.nil?
      #error message
      flash.now[:error] = "Invalid number/password combination." 
      @title = "Sign in"
      render 'new'
    else
      if user.memberships.count == 0 #todo adding if they're new onboard them
        sign_in user
        redirect_to new_group_path
        flash.now[:success] = "Welcome"
      else
        sign_in user
        redirect_back_or user
      end 
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end

end
