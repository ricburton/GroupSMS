class SessionsController < ApplicationController

  def new
    @title = "Sign in"
    @active_page = "signin"
  end

  def create
    number = params[:session][:number]
    #scrubbed_number = %w(0).each{|char| number.sub!(char,'')}
    scrubbed_number = number.gsub!("0","")
    
    #http://stackoverflow.com/questions/4275862/delete-from-string-first-occurrence-of-given-character
    
    user = User.authenticate(scrubbed_number,
                             params[:session][:password])
    if user.nil?
      flash.now[:error] = "Invalid number/password combination." 
      @title = "Sign in"
      render 'new'
    else
      sign_in user
      if user.memberships.count == 0
      redirect_to new_group_path
    else
      redirect_to(:action	=>	'show' , :controller => 'groups',	:id	=> user.memberships.first.group_id)
    end
    
      
      flash.now[:success] = "Welcome"
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end

end
