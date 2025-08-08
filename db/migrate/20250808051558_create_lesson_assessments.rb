class CreateLessonAssessments < ActiveRecord::Migration[8.0]
  def change
    create_table :lesson_assessments do |t|
      t.references :lesson, null: false, foreign_key: true
      t.string :title
      t.text :instructions

      t.timestamps
    end
  end
end
