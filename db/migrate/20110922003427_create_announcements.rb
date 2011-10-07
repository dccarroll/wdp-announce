class CreateAnnouncements < ActiveRecord::Migration
  def self.up
    create_table :announcements do |t|
      t.string :content
      t.integer :user_id
      t.boolean :grade_6
      t.boolean :grade_7
      t.boolean :grade_8
      t.date :start_date
      t.date :end_date
      # todo t.integer :campus

      t.timestamps
    end
      add_index :announcements, [:user_id, :created_at]
    
  end

  def self.down
    drop_table :announcements
  end
end
