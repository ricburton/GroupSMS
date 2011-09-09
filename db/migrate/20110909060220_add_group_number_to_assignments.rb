class AddGroupNumberToAssignments < ActiveRecord::Migration
  def self.up
    add_column :assignments, :group_id, :integer
    add_index :assignments, :group_id
  end

  def self.down
    remove_column :assignments, :group_id
    remove_index :assignments, :group_id
  end
end
