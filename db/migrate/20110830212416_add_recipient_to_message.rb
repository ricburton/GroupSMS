class AddRecipientToMessage < ActiveRecord::Migration
  def self.up
    add_column :messages, :recipient, :integer
    add_column :messages, :api_message_id, :integer
  end

  def self.down
    remove_column :messages, :api_message_id
    remove_column :messages, :recipient
  end
end
