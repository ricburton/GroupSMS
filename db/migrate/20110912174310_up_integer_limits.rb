class UpIntegerLimits < ActiveRecord::Migration
  def self.up
    #change_column :users, :number, :integer, :limit => 8
    #change_column :numbers, :inbound_num, :integer, :limit => 8
  end

  def self.down
    change_column :users, :number, :integer
    change_column :numbers, :inbound_num, :integer
  end
end
