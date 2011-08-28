class AddNumUniquenessIndex < ActiveRecord::Migration
  def self.up
    add_index :users, :number, :unique => true
  end

  def self.down
    remove_index :users, :number
  end
end
