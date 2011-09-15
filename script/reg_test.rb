#def newadded
  @newuser = User.new(:number => "7851864387", :registered => true)
  p @newuser
  p @newuser.memberships.count
  test_user = User.where(:number => @newuser.number).first
  
  if test_user.blank?
    #this is a fresh user that should be saved.
    if @newuser.save
      p "new user saved"
    else
      p "new user not saved"
    end
  elsif test_user.memberships.count < Number.all.count
    p "existing user can be added"
    test_user.toggle!(:registered)
    test_user.memberships.create!(:user_id => test_user.id, :group_id => 1) #pass in live group
    p @newuser
    p @newuser.memberships.count
  elsif test_user.memberships.count >= Number.all.count
    p "existing user cannot be added :("
  end

#end
