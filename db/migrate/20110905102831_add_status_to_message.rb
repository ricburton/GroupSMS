class AddStatusToMessage < ActiveRecord::Migration
  def self.up
    add_column :messages, :status, :string
  end

  def self.down
    remove_column :messages
  end
end
