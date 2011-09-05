class CreateEnvelopesAndAssignments < ActiveRecord::Migration
  def self.up
    create_table :envelopes do |t|
      t.references :user
      t.references :message
      t.timestamps
    end
    create_table :assignments do |t|
      t.references :number
      t.references :user
      t.timestamps
    end
  end

  def self.down
    drop_table :envelopes
    drop_table :assignments
  end
end
