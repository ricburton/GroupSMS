class UpIntegerLimits < ActiveRecord::Migration
  def self.up
    change_column :users, :group_id, :integer, :limit => 10
    change_column :numbers, :inbound_num, :integer, :limit => 10
  end

  def self.down
    change_column :users, :group_id, :integer
    change_column :numbers, :inbound_num, :integer
  end
end
