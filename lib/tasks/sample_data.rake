
require 'faker'
namespace :db do desc "Fill database with sample data" 
  task :populate => :environment do
    Rake::Task['db:reset'].invoke 
    User.create!(:name => "GroupHug",
    :number => "07851864389", 
    :password => "happy123",
    :admin => true,
    :registered => true)
    
    User.create!(:name => "Tim",
    :number => "07851864386", 
    :password => "plokijmn",
    :admin => false,
    :registered => true)
    
    User.create!(:name => "Laurens",
    :number => "07851864387", 
    :password => "plokijmn",
    :admin => false,
    :registered => false)
    
    Assignment.create!(:number_id => 1, :user_id => 3)
    Assignment.create!(:number_id => 2, :user_id => 3)
    Assignment.create!(:number_id => 3, :user_id => 3)
            
    Number.create!(:inbound_num => "447786201383")
    Number.create!(:inbound_num => "447786201384")
    Number.create!(:inbound_num => "447786201385")
    
    Panel.create!(:sending => false, :signup => true, :max_messages => 100)
    
    Notification.create!(:purpose => 'welcome_explanation', :content => "Richard has added you to a GroupHug, it's like chat over SMS. Jack, Keira & Ali are all members of the group: Kite Uist. Text back '+join' to this number to be a part of it.")
    
  end
end


=begin
10.times do |n| name = Faker::Name.name
email = "example-#{n+1}@railstutorial.org" 
password = "password" 
User.create!(:name => name,
:email => email, 
:password => password)
end
=end

#447786201383
#447786201384
#447786201385