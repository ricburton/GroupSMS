class Envelope < ActiveRecord::Base
  belongs_to :messages, :dependent => :destroy
  belongs_to :users, :dependent => :destroy
end
