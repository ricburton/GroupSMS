@assignments = Assignment.all
@numbers = Number.all
current_user = User.first #CHANGE THIS!
max_nums = @numbers.count
#used_nums = current_user.assignments.count

current_user_number_ids = Array.new #numbers the user has been assigned
current_user.assignments.each do |cua|
  current_user_number_ids.push cua.number_id
end

free_nums = Number.where("id != ?", current_user_number_ids) #returns all the nums the user can still be assigned

if  >= @numbers.count
  #puts "you cant start more than " + max_nums.to_s + " groups right now. Sorry!"
else
  #puts "You can start " + free_nums.count.to_s + " new groups"
  free_nums.each do |fn|
   #puts fn.id + fn.inbound_num
  end
end

=begin

number_ids = Array.new
@numbers.each do |number|
  number_ids.push number.id
end
@numbers.each do |num|
  puts "Num id:" + num.id.to_s + " Num:" + num.inbound_num.to_s
end

puts @assignments.to_s

@assignments.each do |ass|
  puts "Num id:" + ass.number_id.to_s
  puts "User id:" + ass.user_id.to_s
end

puts current_user.name + current_user.id.to_s + current_user.assignments.to_s
puts current_user_number_ids

#free_numbers = current_user_number_ids.zip(number_ids)

puts number_ids

cross_over_check = (current_user_number_ids & number_ids).any?

puts cross_over_check


puts used_numbers

#Blog.find(:all,
#          :conditions => ['id NOT IN (?)', the_reader.blog_ids])

#free_numbers = Number.find(:all,
#:conditions => ['id NOT IN (?)', used_numbers])

#free_numbers.each do |fn|
#  puts fn.id.to_s + " " + fn.inbound_num.to_s
#end


=end



