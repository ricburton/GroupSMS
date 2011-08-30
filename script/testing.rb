#puts User.first



@users = User.all
@groups = Group.all
@memberships = Membership.all

@current_user_group_ids =  Array.new

#puts User.first.memberships

users_filtered = @users.find_all{|uid| uid.name == "Richard"}

#puts users_filtered

all_group_ids = @memberships.each do |m|
  m.group_id.to_s
  
  #puts "group_id = " + m.group_id.to_s
  #puts "user_id = " + m.user_id.to_s
end

#puts all_group_ids.join(',')

@user_group_ids = Array.new

@memberships.each do |m|
  if m.user_id == @users.first.id #change @users.first to current user
    @user_group_ids.push m.group_id
  end
end

#puts @user_group_ids

#puts @groups.class

groups_hash = {
  1 => "Kiting",
  2 => "Love",
  23 => "Business",
  24 => "Awesome"
}

#puts groups_hash[1]

test_hash = Hash.new

current_group_names = @groups.find_all{|group| @user_group_ids.include? group.group_name}

puts current_group_names

Group.where(:id => @user_group_ids ).all.each do |g|
  puts g.group_name
end

@groups.each do |g|
  puts g.group_name
end

=begin
@users = Array.new

User.all.each do |u|
  @users.push u.id.to_s
  #puts u.id
end

puts @users

=end