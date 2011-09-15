
@user.number.nil? ? test = "" : test = User.where(:number => @user.number)

if test.blank?
  #already a non-registered member
  @user.toggle!(:registered)
else
  if @user.memberships.count > 0
    user_group_ids = Array.new
    @user.memberships.each do |member|
      user_group_ids.push member.group_id
    end

    user_groups = Group.where(:id => user_group_ids).all.each

    user_groups.each do |group|
      p group.name
    end  
  else
    flash.now[:error] = "Caught a random occurrence with user saving."
    redirect_to root_path
  end
end

if @user.save
else
  #todo redirection not working.
  flash.now[:error] = "Welcome"
  redirect_to root_path
end


