#todo - Non-Admins: Called id for nil, which would mistakenly be 4 -- if you really wanted the id of nil, use object_id

class GroupsController < ApplicationController
  before_filter :authenticate, :only => [:edit, :update, :show, :destroy, :create]
  before_filter :correct_user, :only => [:edit, :update] #TODO - work out how to only show the correct user's groups
  #before_filter :admin_user, :only => [:index, :destroy]


  def index
    @groups = Group.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @group = Group.find(params[:id])
    @groups = Group.all
    @users = User.all
    @memberships = Membership.all
    @user_group_ids = Array.new
    @memberships.each do |m|
      if m.user_id == current_user.id #change @users.first to current user
        @user_group_ids.push m.group_id
      end
    end
    @user_groups = Group.where(:id => @user_group_ids ).all.each

    @group_user_ids = Array.new

    @group.memberships.each do |gm|
      if gm.group_id == @group.id
        @group_user_ids.push gm.user_id
      end
    end


    @group_members = User.where(:id => @user_group_ids ).all.each

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def new
    @group = Group.new
    @max_nums = Number.all.count
    @used_nums = current_user.assignments.count

    if @used_nums >= @max_nums
      flash.now[:error] = "XXXXWe're really sorry but you can only start or be added to #{@max_nums.to_s} groups at the moment."
      #Todo - disable the group-creation form
      #todo - make the error red

      @hide_form = true
    else
      remaining_nums = @max_nums - @used_nums
      flash.now[:success] = "You're free to start or be added to #{remaining_nums} groups." #todo - pluralization check
    end

    @group.users.build
  end

  def edit
    @group = Group.find(params[:id])
  end

  def create #todo test for number of groups they're already in before creation
    @group = Group.new(params[:group]) #todo must not be able to access group creation if not signed in
    @assignments = Assignment.all
    @numbers = Number.all

    current_user_number_ids = Array.new #numbers the user has been assigned
    current_user.assignments.each do |cua|
      current_user_number_ids.push cua.number_id
    end

    all_number_ids = Array.new
    @numbers.each do |number|
      all_number_ids.push number.id
    end

    free_number_ids = all_number_ids - current_user_number_ids
    
    current_user.assignments.create!(:number_id => free_number_ids.first, :user_id => current_user.id)
    @group.memberships.build(:user_id => current_user.id, :group_id => @group.id)
    #TODO - need to stop group creation happening on model side if they're out of numbers!

    respond_to do |format|
      if @group.save
        #creator-user attributes

        #current_user.creator = true #TODO - get this to work...
        #member-user attributes
        @group.users.each do |x|
          @group.memberships.create!(:user_id => x.id, :group_id => @group.id)
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
      format.html { redirect_to(groups_url) }
    end
  end
end


=begin

# ever user assignment creation algo

#creator-user attributes
current_user.creator = true #TODO - get this to work...
@group.memberships.create!(:user_id => current_user.id, :group_id => @group.id)
current_user.assignments.create!(:user_id => current_user.id, :number_id => free_nums.first.id)

#member-user attributes
@group.users.each do |x|
@group.memberships.create!(:user_id => x.id, :group_id => @group.id)
if x.assignments >= @numbers.count
flash.now[:error] = "We're really sorry but #{x.name} already belongs to #{@max_nums.to_s} groups."
elsif x.assignments == 0
x.assignments.create!(:user_id => x.id, :number_id => @numbers.first.id)
else
fresh_user_number_ids = Array.new
x.assignments.each do |ass|
fresh_user_number_ids.push x.number_id
end
free_nums_for_fresh_user = Number.find(:all, :conditions => ['id NOT IN (?)', fresh_user_number_ids])
x.assignments.create!(:user_id => x.id, :number_id => free_nums_for_fresh_user.first.id)
end
end

=end
