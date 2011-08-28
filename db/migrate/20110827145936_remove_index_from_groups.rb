class RemoveIndexFromGroups < ActiveRecord::Migration
  def self.up
    remove_index :groups, :user_id
  end

  def self.down
    add_index :groups, :user_id, :integer
  end
end
