class RemoveUserIdFromNums < ActiveRecord::Migration
  def self.up
    remove_column :numbers, :user_id
  end

  def self.down
  end
end
