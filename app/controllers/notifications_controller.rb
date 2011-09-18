class NotificationsController < ApplicationController
   before_filter :authenticate
   before_filter :admin_user, :only => [:index, :create, :show, :destroy, :edit]
   def index
      @notifications = Notification.all

      respond_to do |format|
         format.html
      end
   end

   def show
      @notification = Notification.find(params[:id])

      respond_to do |format|
         format.html
      end
   end

   def new
      @notification = Notification.new

      respond_to do |format|
         format.html
      end
   end

   def edit
      @notification = Notification.find(params[:id])
   end

   def create
      @notification = Notification.new(params[:notification])

      respond_to do |format|
         if @notification.save
            format.html { redirect_to(@notification, :notice => 'Notification was successfully created.') }
         else
            format.html { render :action => "new" }
         end
      end
   end

   def update
      @notification = Notification.find(params[:id])

      respond_to do |format|
         if @notification.update_attributes(params[:notification])
            format.html { redirect_to(@notification, :notice => 'Notification was successfully updated.') }
            format.xml  { head :ok }
         else
            format.html { render :action => "edit" }
            format.xml  { render :xml => @notification.errors, :status => :unprocessable_entity }
         end
      end
   end

   def destroy
      @notification = Notification.find(params[:id])
      @notification.destroy

      respond_to do |format|
         format.html { redirect_to(notifications_url) }
         format.xml  { head :ok }
      end
   end
end
