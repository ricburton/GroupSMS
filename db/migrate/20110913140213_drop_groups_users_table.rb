class DropGroupsUsersTable < ActiveRecord::Migration
  def self.up
    drop_table :groups_users
  end

  def self.down
    create_table :groups_users
  end
end
