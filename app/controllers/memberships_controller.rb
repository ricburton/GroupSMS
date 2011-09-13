class MembershipsController < ApplicationController
  before_filter :authenticate
  def index
    @memberships = Membership.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def new
   # @membership = Membership.new
    

    #   respond_to do |format|
    #     format.html # new.html.erb
    #   end
  end

  def create
    #@membership = Membership.new(params[:membership])
    
    #if @memebership.save
    #  format.html { redirect_to(@membership, :notice => 'Group was successfully created.') }
    #else
    #  format.html { render :action => "new" }
    #end
    
    #@user = User.find(params[:membership][:group_id])
    #current_user.join!(@user)
    #redirect_to @user
    
  end
  
  def destroy
    @membership = Membership.find(params[:id])
    @membership.destroy
    redirect_to root_path
  end

end
