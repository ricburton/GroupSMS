class MoveCreatorToMembership < ActiveRecord::Migration
  def self.up
    remove_column :users, :creator
    add_column :memberships, :creator, :boolean
  end

  def self.down
    add_column :users, :creator, :boolean
    remove_column :memberships, :creator
  end
end
