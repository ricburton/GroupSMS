class SessionsController < ApplicationController


  def new
    @title = "Sign in"
  end

  def create #todo when signing up the person isn't signing in...
    user = User.authenticate(params[:session][:number],params[:session][:password])
    if user.nil?
      #error message
      flash.now[:error] = "Invalid email/password combination." 
      @title = "Sign in"
      render 'new'
    else
      #sign_in
      flash.now[:success] = "Welcome"
      sign_in user
      redirect_back_or user
    end
  end
  
  def destroy
    sign_out
    redirect_to root_path
  end

end
