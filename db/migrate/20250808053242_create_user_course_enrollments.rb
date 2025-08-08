class CreateUserCourseEnrollments < ActiveRecord::Migration[8.0]
  def change
    create_table :user_course_enrollments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :course, null: false, foreign_key: true
      t.integer :status, default: 0
      t.integer :progress, default: 0
      t.datetime :enrolled_at
      t.datetime :completed_at

      t.timestamps
    end
  end
end
