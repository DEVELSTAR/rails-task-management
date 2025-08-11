class UserCourseEnrollment < ApplicationRecord
  belongs_to :course, counter_cache: true
  belongs_to :user, counter_cache: true
  enum :status, {
    in_progress: 0,
    completed: 1,
    expired: 2
  }

  validates :status, presence: true
  validates :progress, numericality: { in: 0..100 }

  def self.ransackable_associations(auth_object = nil)
    ["user", "course"]
  end

  def recalculate_progress!
    course_module_ids = course.course_modules.pluck(:id)
    total_items = Lesson
      .where(course_module_id: course_module_ids)
      .count + (course.final_assessment.present? ? 1 : 0)

    return if total_items.zero?

    completed_lessons = user.user_lesson_statuses
      .where(lesson_id: Lesson.where(course_module_id: course_module_ids), status: :completed)
      .count

    final_completed = course.final_assessment &&
      user.user_assessment_results.exists?(assessment: course.final_assessment)

    completed_items = completed_lessons + (final_completed ? 1 : 0)
    progress = ((completed_items.to_f / total_items) * 100).round

    update(progress: progress, status: progress == 100 ? :completed : :in_progress)
  end
end
