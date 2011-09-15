class GroupsController < ApplicationController
  before_filter :authenticate
  #before_filter :authenticate, :only => [:edit, :update, :show, :destroy, :create]
  #before_filter :correct_user, :only => [:edit, :update]
  #before_filter :admin_user, :only => [:index, :destroy, :edit, :show]

  def index
    @groups = Group.all

    respond_to do |format|
      format.html
    end
  end

  def show
    @group = Group.find(params[:id])
    @message = Message.new
    @active_page = "UserHome"
    @max_nums = Number.all.count
    @used_nums = current_user.memberships.count
    if @used_nums == @max_nums
      @hide_form = true
    end
    @group_messages = Message.order("created_at DESC").where(:group_id => @group.id)

    user_group_ids = Array.new    
    current_user.memberships.each do |cuser|
      user_group_ids.push cuser.group_id
    end
    @user_groups = Group.where(:id => user_group_ids ).all.each

    all_group_assignments = Assignment.where(:group_id => @group.id).all.each
    all_group_memberships = Membership.where(:group_id => @group.id).all.each

    group_user_ids = Array.new
    all_group_memberships.each do |membership|
      group_user_ids.push membership.user_id
    end

    user_number_ids = Array.new
    all_group_assignments.each do |ass|
      user_number_ids.push ass.number_id
    end

    @group_users = User.where(:id => group_user_ids ).all.each
    @user_numbers = Number.where(:id => user_number_ids).all.each
    respond_to do |format|
      format.html
    end

    #    if current_user.memberships.count == Number.all.count
    #      @hide_form = true
    #    end

  end

  def new
    @group = Group.new
    @max_nums = Number.all.count
    @used_nums = current_user.memberships.count
    if @used_nums == @max_nums
      @hide_form = true
    end

    @group.users.build
  end

  def edit
    @group = Group.find(params[:id])
  end

  def create
    @group = Group.new(params[:group])
    @assignments = Assignment.all
    @numbers = Number.all

    @group.creator_id = current_user.id

    current_user_number_ids = Array.new #numbers the user has been assigned
    current_user.assignments.each do |cua|
      current_user_number_ids.push cua.number_id
    end

    all_number_ids = Array.new
    @numbers.each do |number|
      all_number_ids.push number.id
    end

    free_number_ids = all_number_ids - current_user_number_ids

    respond_to do |format|

      if @group.save
        ### creator-user attributes ###
        current_user.assignments.create!(:number_id => free_number_ids.first, 
        :user_id => current_user.id,
        :group_id => @group.id)

        current_user.memberships.create!(:user_id => current_user.id,
        :group_id => @group.id)



        #current_user(:creator => true) #TODO - get this to work...

        ### member-user attributes ###
        member_number_ids = Array.new

        @group.users.each do |x|
          @group.memberships.create!(:user_id => x.id, :group_id => @group.id)

          x.assignments.each do |ass|
            member_number_ids.push ass.number_id
          end

          free_number_ids_for_member = all_number_ids - member_number_ids
          x.assignments.create!(:number_id => free_number_ids_for_member.first, 
          :user_id => x.id, 
          :group_id => @group.id)   

        end

        format.html { redirect_to(@group, :notice => 'Success!') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  #logger.info @group.users
  #logger.info params[:group][:users_attributes]

  #@user = User.new



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
      format.html { redirect_to root_path }
    end
  end
end
