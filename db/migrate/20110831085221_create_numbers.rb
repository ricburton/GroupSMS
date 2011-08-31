class CreateNumbers < ActiveRecord::Migration
  def self.up
    create_table :numbers do |t|
      t.integer :inbound_num
      t.boolean :assigned

      t.timestamps
    end
  end

  def self.down
    drop_table :numbers
  end
end
