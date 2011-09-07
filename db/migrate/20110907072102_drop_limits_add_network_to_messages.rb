class DropLimitsAddNetworkToMessages < ActiveRecord::Migration
  def self.up
    drop_table :limits
    add_column :messages, :network, :string
  end

  def self.down
  end
end
