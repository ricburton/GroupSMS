class Message < ActiveRecord::Base
  has_many :envelopes
  has_many :users, :through => :envelopes
  accepts_nested_attributes_for :envelopes
end
