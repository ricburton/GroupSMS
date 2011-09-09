
require 'faker'
namespace :db do desc "Fill database with sample data" 
  task :populate => :environment do
    Rake::Task['db:reset'].invoke 
    User.create!(:name => "Richard",
    :number => "07851864388", 
    :password => "happy123",
    :admin => true,
    :registered => true)
    
    User.create!(:name => "Tim",
    :number => "07851864389", 
    :password => "plokijmn",
    :admin => false,
    :registered => true)
    
    User.create!(:name => "Laurens",
    :number => "07851864387", 
    :password => "plokijmn",
    :admin => false,
    :registered => false)
    
    Number.create!(:inbound_num => "447786201383")
    Number.create!(:inbound_num => "447786201384")
    Number.create!(:inbound_num => "447786201385")
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