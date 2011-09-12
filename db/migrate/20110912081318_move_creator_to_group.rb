class MoveCreatorToGroup < ActiveRecord::Migration
  def self.up
    remove_column :memberships, :creator
    add_column :groups, :creator_id, :integer
  end

  def self.down
    remove_column :groups, :creator_id
    add_column :memberships, :creator, :boolean
  end
end
