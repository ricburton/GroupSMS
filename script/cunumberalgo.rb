current_user = User.first
@group = Group.first

p current_user

current_user_group_number_id = Assignment.where(:user_id => current_user.id, :group_id => @group.id).first

p current_user_group_number_id

#@current_user_group_number = Number.find(current_user_group_number_id).first.number
