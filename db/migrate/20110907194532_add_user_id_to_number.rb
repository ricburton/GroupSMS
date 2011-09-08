class AddUserIdToNumber < ActiveRecord::Migration
  def self.up
    add_column :numbers, :user_id, :integer
    add_index :numbers, :user_id
  end

  def self.down
    remove_column :numbers, :user_id
  end
end
