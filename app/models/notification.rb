class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :course, optional: true

  enum :notification_type, {
    enrolled: "enrolled",
    lesson_completed: "lesson_completed",
    course_completed: "course_completed"
  }

  scope :unread, -> { where(read: false) }
  scope :recent, -> { order(created_at: :desc) }

  def mark_as_read!
    update(read: true, read_at: Time.current)
  end

  def description
    case notification_type
    when "enrolled"
      "#{user.email} enrolled in #{course.title}"
    when "lesson_completed"
      "#{user.email} completed a lesson in #{course.title}"
    when "course_completed"
      "#{user.email} completed the course #{course.title}"
    else
      "Activity by #{user.email}"
    end
  end

  def self.ransackable_associations(auth_object = nil)
    ["course", "user"]
  end
end
