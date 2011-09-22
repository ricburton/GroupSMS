creator_name = "Alex Parker"
group_name = "Kite Uist"

test = "#{creator_name} has added you to a GroupHug called #{group_name}. It's like chat over SMS where one text reaches all the members. Reply with '+join' to opt-in."

p test

replacements = {
   "#{creator_name}" => creator_name,
   "#{group_name}" => group_name
}

replacements.each do |string, var|
   test.gsub!(string, var)
end

p test