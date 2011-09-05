class AddStatusToMembershipsAndConvertStringToTextInMessages < ActiveRecord::Migration
  def self.up
    add_column :memberships, :status, :string
  end

  def self.down
  end
end
