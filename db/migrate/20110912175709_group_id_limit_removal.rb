class GroupIdLimitRemoval < ActiveRecord::Migration
  def self.up
    change_column :users, :group_id, :integer, :limit => false
  end

  def self.down
    change_column :users, :group_id, :integer
  end
end
