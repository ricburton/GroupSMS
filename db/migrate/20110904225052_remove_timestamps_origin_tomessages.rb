class RemoveTimestampsOriginTomessages < ActiveRecord::Migration
  def self.up
    add_column :messages, :origin, :string
    add_column :messages, :timestamps, :datetime
  end

  def self.down
    remove_column :messages, :origin, :string

  end
end
