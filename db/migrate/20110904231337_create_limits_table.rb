class CreateLimitsTable < ActiveRecord::Migration
  def self.up
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
