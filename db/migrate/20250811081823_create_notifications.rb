# db/migrate/20250810120000_create_notifications.rb
class CreateNotifications < ActiveRecord::Migration[8.0]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.references :course, foreign_key: true
      t.string :notification_type, null: false # e.g. "enrolled", "lesson_completed", "course_completed"
      t.boolean :read, default: false
      t.datetime :read_at
      t.timestamps
    end
  end
end
