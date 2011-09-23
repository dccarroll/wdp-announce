class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :name
      t.string :email
      t.integer :grade
      #todo t.integer :campus

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
