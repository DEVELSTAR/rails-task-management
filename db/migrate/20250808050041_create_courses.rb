class CreateCourses < ActiveRecord::Migration[8.0]
  def change
    create_table :courses do |t|
      t.string :title
      t.text :description
      t.integer :duration
      t.string :slug
      t.string :image
      t.decimal :price
      t.integer :status, default: 0
      t.string :language
      t.integer :level, default: 0
      t.boolean :is_published

      t.timestamps
    end
  end
end
