class AddFromToMessages < ActiveRecord::Migration
  def self.up
    add_column :messages, :from, :integer
  end

  def self.down
    remove_column :messages, :from
  end
end
