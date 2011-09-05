class RemoveTusersTroupsTextsSubjects < ActiveRecord::Migration
  def self.up
    drop_table :tusers
    drop_table :troups
    drop_table :texts
    drop_table :subjects
  end

  def self.down
    create_table :tusers
    create_table :troups
    create_table :texts
    create_table :subjects
  end
end
