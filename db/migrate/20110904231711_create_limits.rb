class CreateLimits < ActiveRecord::Migration
  def self.up
    drop_table :limits
    create_table :limits do |t|
      t.string :type
      t.integer :amount

      t.timestamps
    end
  end

  def self.down
    drop_table :limits
  end
end
