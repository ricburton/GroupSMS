class AddApiTimestampToMessages < ActiveRecord::Migration
  def self.up
    add_column :messages, :api_timestamp, :datetime
  end

  def self.down
    remove_column :messages, :api_timestamp
  end
end
