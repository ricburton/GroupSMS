class ChangeGroupNameToGroup < ActiveRecord::Migration
  def self.up
    rename_column :groups, :group_name, :name
  end

  def self.down
    rename_column :groups, :name, :group_name
  end
end
