class AddEnvelopeIdToMessages < ActiveRecord::Migration
  def self.up
    add_column :users, :envelope_id, :integer
    add_index :users, :envelope_id
  end

  def self.down
    remove_column :users, :envelope_id
    remove_index :users, :envelope_id
  end
end
