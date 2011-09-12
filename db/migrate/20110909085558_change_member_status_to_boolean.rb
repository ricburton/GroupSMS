class ChangeMemberStatusToBoolean < ActiveRecord::Migration
  def self.up
    create_table :memberships do |t|
      t.integer :user_id
      t.integer :group_id
      t.boolean :active
      
      t.timestamps
    end
  end

  def self.down
  end
end
