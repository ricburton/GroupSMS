# == Schema Information
# Schema version: 20110826221216
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  number     :string(255)
#  created_at :datetime
#  updated_at :datetime
#  group_id   :integer
#
require 'digest'
class User < ActiveRecord::Base
  
  has_many :memberships
  has_many :groups, :through => :memberships
  
  attr_accessible :group_name, :user_name, :user_number
  accepts_nested_attributes_for :groups
  attr_writer :group_name, :user_name, :user_number
  
  
=begin

def following?(followed) relationships.find_by_followed_id(followed)
end
def follow!(followed) relationships.create!(:followed_id => followed.id)
end

=end  
  
=begin  
  has_many :memberships, :foreign_key => "group_id" #it's either group_id OR user_id...
           
  has_many :groups, :through => :memberships, :source => :joined
  
  def member?(joined)
    memberships.find_by_group_id(joined)
  end
  
  def member!(joined)
    memberships.create!(:membership_id => joined.id)
  end
  
  def leave!(joined)
    memberships.find_by_group_id(joined).destroy
  end
=end  
  
  
  
  attr_accessor :password
  attr_accessible :name, :number, :password

  

  mobile_regex = /\A(([0][7][5-9])(\d{8}))\Z/

  validates :name,     :presence => true, #todo regexp for first name only
  :length => { :maximum => 15 }
  validates :number,   :presence => true,
  :format => { :with => mobile_regex },
  :uniqueness => true

  validates :password, :presence	=> true,
  :confirmation => true,
  :length	=> { :within => 6..40 }

  before_save :encrypt_password

  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end
  
  def self.authenticate(number, submitted_password)
    user = find_by_number(number)
    return nil  if user.nil?
    return user if user.has_password?(submitted_password)
  end
  
  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil #ternary operator here
    #return nil if user.nil?
    #return user if user.salt == cookie_salt
    # EG
    # >> var = 3
    # => 3
    # >> var == 3 ? puts("its a 3") : puts("its not a 3")
    # its a 3
  end
  
  private

  def encrypt_password
    self.salt = make_salt if new_record?
    self.encrypted_password = encrypt(password)
  end

  def encrypt(string)
    secure_hash("#{salt}--#{string}")
  end
  
  def make_salt
    secure_hash("#{Time.now.utc}--#{password}")
  end
  
  def secure_hash(string)
    Digest::SHA2.hexdigest(string)
  end


end
