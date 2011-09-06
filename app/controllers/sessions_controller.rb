class SessionsController < ApplicationController


  def new
    @title = "Sign in"
  end

  def create #todo when signing up the person isn't signing in...
    user = User.authenticate(params[:session][:number],params[:session][:password])
    if user.nil?
      flash.now[:error] = "Invalid number/password combination." 
      @title = "Sign in"
      render 'new'
    else
        sign_in user
        redirect_to user #todo fix redirection to new group path
        
        flash.now[:success] = "Welcome"
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end

end
