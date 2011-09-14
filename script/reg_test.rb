#@user = User.first
#@user = User.find(3)
@user = User.new(:registered => false)

p @user


@user.number.nil? ? test = "" : test = User.where(:number => @user.number)

p test

#todo - how to handle creation if it's on a group level or new signup

if test.blank?
  p "this is a fresh user"
  @user.toggle!(:registered)
  p @user
else
  p "this is a registered user that belongs to:"
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
    p "You don't belong to any groups"
  end
end

