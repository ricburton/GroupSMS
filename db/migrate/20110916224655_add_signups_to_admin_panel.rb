class AddSignupsToAdminPanel < ActiveRecord::Migration
  def self.up
    add_column :panels, :signup, :boolean
  end

  def self.down
    remove_column :panels, :signup
  end
end
