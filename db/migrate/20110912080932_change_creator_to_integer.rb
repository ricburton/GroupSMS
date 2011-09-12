class ChangeCreatorToInteger < ActiveRecord::Migration
  def self.up
    change_column :memberships, :creator, :integer
  end

  def self.down
    change_column :memberships, :creator, :boolean
  end
end
