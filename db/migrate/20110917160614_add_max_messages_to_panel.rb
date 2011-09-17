class AddMaxMessagesToPanel < ActiveRecord::Migration
  def self.up
     add_column :panels, :max_messages, :integer
  end

  def self.down
     remove_column :panels, :max_messages
  end
end
