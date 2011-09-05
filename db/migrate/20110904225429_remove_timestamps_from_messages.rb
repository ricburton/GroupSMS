class RemoveTimestampsFromMessages < ActiveRecord::Migration
  def self.up
    remove_column :messages, :timestamps, :datetime
  end

  def self.down
  end
end
