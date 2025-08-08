class CreateLessonContents < ActiveRecord::Migration[8.0]
  def change
    create_table :lesson_contents do |t|
      t.references :lesson, null: false, foreign_key: true
      t.integer :content_type, default: 0
      t.jsonb :content_data
      t.integer :position

      t.timestamps
    end
  end
end
