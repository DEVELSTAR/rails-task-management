class AddCountFieldsToCoursesAndUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :courses, :course_modules_count, :integer
    add_column :courses, :user_course_enrollments_count, :integer
    add_column :users, :user_course_enrollments_count, :integer
  end
end
