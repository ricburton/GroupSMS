#todo - Non-Admins: Called id for nil, which would mistakenly be 4 -- if you really wanted the id of nil, use object_id

class GroupsController < ApplicationController
  before_filter :authenticate, :only => [:index, :edit, :update, :destroy, :show]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user, :only => [:destroy]

  def index
    @groups = Group.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @group = Group.find(params[:id])    
    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def new
    @group = Group.new
    # @group.build_user

  end

  def edit
    @group = Group.find(params[:id])
  end

  def create #todo test for number of groups they're already in before creation


    @group = Group.new(params[:group]) #todo must not be able to access group creation
    @group.memberships.build(:user_id => current_user.id)
    logger.info @group.users
    
    @group.users.each do |x|
      @group.reload.memberships.build(:user_id => x.id )
    end
    
    #@group.each do |y|
    #  @group.memberships.build(:user_id => y.user_id)
    #end
    
    respond_to do |format|
      if @group.save
        format.html { redirect_to(@group, :notice => 'Success!') }
      else
        format.html { render :action => "new" }
      end
    end


  end


  def update
    @group = Group.find(params[:id])

    respond_to do |format|
      if @group.update_attributes(params[:group])
        format.html { redirect_to(@group, :notice => 'Group was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @group = Group.find(params[:id])
    @group.destroy

    respond_to do |format|
      format.html { redirect_to(groups_url) }
    end
  end
end
