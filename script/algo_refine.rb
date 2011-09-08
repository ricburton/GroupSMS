@assignments = Assignment.all
@numbers = Number.all
current_user = User.first

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

