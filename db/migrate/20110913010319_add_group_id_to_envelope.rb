class AddGroupIdToEnvelope < ActiveRecord::Migration
  def self.up
    add_column :envelopes, :group_id, :integer
    add_index :envelopes, :group_id
  end

  def self.down
    remove_column :envelopes, :group_id
    remove_index :envelopes, :group_id
  end
end
