class CreateTexts < ActiveRecord::Migration
  def self.up
    create_table :texts do |t|
      t.string :content
      t.integer :group_id
      t.integer :user_id

      t.timestamps
    end
    add_index :texts, :user_id
  end

  def self.down
    drop_table :texts
  end
end
