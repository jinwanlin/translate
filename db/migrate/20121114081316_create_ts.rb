class CreateTs < ActiveRecord::Migration
  def change
    create_table :ts do |t|
      t.string :words
      t.text :meanings
      t.integer :t_count
      t.integer :level
      
      t.timestamps
    end
  end
end
