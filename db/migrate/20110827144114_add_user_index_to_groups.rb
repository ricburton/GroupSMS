class AddUserIndexToGroups < ActiveRecord::Migration
  def self.up
    add_column :groups, :user_id, :integer
    add_index :groups, :user_id
  end

  def self.down
    remove_column :groups, :user_id
    remove_index :groups, :user_id
  end
end
