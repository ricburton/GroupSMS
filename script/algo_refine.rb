@assignments = Assignment.all
@numbers = Number.all
current_user = User.first

current_user_number_ids = Array.new #numbers the user has been assigned
current_user.assignments.each do |cua|
  current_user_number_ids.push cua.number_id
end

puts current_user_number_ids
puts current_user_number_ids.count

free_nums = Number.find(:all, :conditions => ['id NOT IN (?)', current_user_number_ids])

free_nums.each do |freenum|
  puts freenum.inbound_num
end

