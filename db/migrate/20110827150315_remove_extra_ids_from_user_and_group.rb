class RemoveExtraIdsFromUserAndGroup < ActiveRecord::Migration
  def self.up
    remove_column :users, :group_id
    remove_column :groups, :user_id
  end

  def self.down
    add_column :users, :group_id, :integer
    add_column :groups, :user_id, :integer
  end
end
