class GroupsController < ApplicationController
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
    
    #3.times { @group.user.build }
  end

  def edit
    @group = Group.find(params[:id])
  end

  def create #todo test for number of groups they're already in before creation
    @group = Group.new(params[:group])
    @group.memberships.build(:user_id => current_user.id)
    #@group..build
    
    respond_to do |format|
      if @group.save
        format.html { redirect_to(@group, :notice => 'Group was successfully created and user added...?') }
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
