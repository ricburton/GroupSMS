class ChangeMemberStatusToBoolean < ActiveRecord::Migration
  def self.up
    change_column :memberships, :status, :boolean
  end

  def self.down
  end
end
