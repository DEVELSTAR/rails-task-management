class CreateCoursePackages < ActiveRecord::Migration[8.0]
  def change
    create_table :course_packages do |t|
      t.references :course, null: false, foreign_key: true
      t.references :package, null: false, foreign_key: true

      t.timestamps
    end
  end
end
