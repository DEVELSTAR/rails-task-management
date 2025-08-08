class CreateUserLessonStatuses < ActiveRecord::Migration[8.0]
  def change
    create_table :user_lesson_statuses do |t|
      t.references :user, null: false, foreign_key: true
      t.references :lesson, null: false, foreign_key: true
      t.integer :status
      t.integer :score
      t.datetime :completed_at

      t.timestamps
    end
  end
end
