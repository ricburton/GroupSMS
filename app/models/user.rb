require 'digest'
class User < ActiveRecord::Base

  has_many :memberships
  has_many :groups, :through => :memberships
  belongs_to :group

  #does this work?
  has_many :assignments
  has_many :numbers, :through => :assignments, :uniq => true
  accepts_nested_attributes_for :numbers

  #attr_accessible :name, :user_name, :user_number
  #accepts_nested_attributes_for :groups
  #attr_writer :name, :user_name, :user_number


  before_destroy { |user| 
    user.memberships.destroy_all
    user.assignments.destroy_all
  }


  attr_accessor :password
  #attr_accessible :name, :number, :password



  #mobile_regex = /\A(([0][7][5-9])(\d{8}))\Z/

  validates :name,     :presence => true, #todo regexp for first name only
  :length => { :maximum => 15 },
  :format => { :with => /\A[a-zA-Z]+\z/, :message => "Only letters allowed" }
  
  validates :number, #todo - fix mobile regexp
  :presence => true,
  :length => { :minimum => 5, :maximum => 11},
  #:format => { :with => mobile_regex },
  :uniqueness => true
  #TODO - uniqeness checking still needs to be handled properly.

  validates :password, :presence	=> true,
  :confirmation => true,
  :length	=> { :within => 6..40 }

  before_save :encrypt_password

  #before_create callback - set defaults


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
