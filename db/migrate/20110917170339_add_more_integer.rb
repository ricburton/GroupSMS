class AddMoreInteger < ActiveRecord::Migration
  def self.up
    change_column :messages, :recipient, :integer, :limit => 8
    change_column :messages, :api_message_id, :integer, :limit => 8
    change_column :messages, :from, :integer, :limit => 8
  end

  def self.down
  end
end
