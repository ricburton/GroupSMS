class AddSomeIndeces < ActiveRecord::Migration
  def self.up
    add_column :users, :number_id, :integer
    add_index :users, :number_id
    
    add_column :messages, :user_id, :integer
    add_index :messages, :user_id
    
    add_column :groups, :number_id, :integer
    add_index :groups, :number_id
  end

  def self.down
    remove_index :user, :number_id
    remove_index :message, :user_id
    remove_index :group, :number_id
  end
end
