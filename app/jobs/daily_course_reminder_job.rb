class DailyCourseReminderJob < ApplicationJob
  queue_as :default

  def perform
    UserCourseEnrollment.includes(:user, course: [:lessons, :final_assessment]).find_each do |enrollment|
      course = enrollment.course
      user   = enrollment.user

      next if enrollment.status == "completed"

      message = next_required_action_message(user, course)

      if message.present?
        Notification.create!(
          user: user,
          course: course,
          notification_type: :reminder,
          message: message
        )
      end
    end
  end

  private

  def next_required_action_message(user, course)
    course.lessons.order(:position).each do |lesson|
      lesson_status = user.user_lesson_statuses.find_by(lesson: lesson)
      return "Please start #{lesson.title}" if lesson_status.nil? || lesson_status.not_started? || lesson_status.in_progress?

      if lesson.lesson_assessment.present?
        result = user.user_assessment_results.find_by(assessment: lesson.lesson_assessment)
        return "Please complete the assessment for #{lesson.title}" if result.nil?
      end
    end

    if course.final_assessment.present?
      final_result = user.user_assessment_results.find_by(assessment: course.final_assessment)
      return "Please complete the final course assessment" if final_result.nil?
    end

    nil
  end
end
