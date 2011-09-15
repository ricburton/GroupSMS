class RemoveTextsTable < ActiveRecord::Migration
  def self.up
    drop_table :texts
  end

  def self.down
  end
end
