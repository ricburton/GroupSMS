user_memberships = Array.new
User.first.memberships.each {|mem| user_memberships.push mem.group_id}
@belonging_groups = Group.where(:id => user_memberships)

