class MembershipsController < ApplicationController
   before_filter :authenticate
   before_filter :admin_user, :only => [:index]
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

   def edit
      @membership = Membership.find(params[:id])
   end
   
   def toggle
      @membership = Membership.find(params[:id])
      @membership.toggle!(active)
   end
   
   def toggleon
      @membership = Membership.find(params[:id])
      @membership.update_attributes(:active => true)
      if user.id == membership_id 
         redirect_to root_path
      else
         redirect_to group
      end
   end

   def toggleoff
      @membership = Membership.find(params[:id])
      @membership.update_attributes(:active => false)
            if user.id == membership_id 
         redirect_to root_path
      else
         redirect_to group
      end
   end

   def update
      @membership = Membership.find(params[:id])

      respond_to do |format|
         if @membership.update_attributes(params[:membership])
            format.html { redirect_to(memberships_path, :notice => 'membership was successfully updated.') }
         else
            format.html { render :action => "edit" }
         end
      end
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
      group = Group.find(@membership.group_id)
      user = User.find(@membership.user_id)
      membership_id = @membership.user_id
      @membership.destroy

      if user.id == membership_id 
         redirect_to root_path
      else
         redirect_to group
      end
   end

end
