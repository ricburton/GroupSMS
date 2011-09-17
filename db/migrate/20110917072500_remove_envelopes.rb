class RemoveEnvelopes < ActiveRecord::Migration
  def self.up
     drop_table :envelopes
  end

  def self.down
  end
end
