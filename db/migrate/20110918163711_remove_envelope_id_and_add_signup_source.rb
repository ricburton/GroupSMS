class RemoveEnvelopeIdAndAddSignupSource < ActiveRecord::Migration
  def self.up
     remove_column :users, :envelope_id
     add_column :users, :signup_source, :string
  end

  def self.down
  end
end
