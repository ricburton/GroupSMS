class RemoveAssignedFromNumbers < ActiveRecord::Migration
  def self.up
     remove_column :numbers, :assigned
  end

  def self.down
     add_column :numbers, :assigned, :boolean
  end
end
