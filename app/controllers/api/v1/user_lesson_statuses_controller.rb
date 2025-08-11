module Api
  module V1
    class UserLessonStatusesController < ApplicationController
      def update
        lesson = Lesson.find(params[:id])
        course = lesson.course
        enrollment = current_user.user_course_enrollments.find_by(course: course)

        if enrollment
          user_lesson_status = current_user.user_lesson_statuses.find_or_initialize_by(lesson: lesson)

          user_lesson_status.status = params[:status]

          if user_lesson_status.save
            enrollment.recalculate_progress!
            render json: {
              lesson_id: lesson.id,
              status: user_lesson_status.status
            }
          else
            render json: { errors: user_lesson_status.errors.full_messages }, status: :unprocessable_entity
          end
        else
          render json: { error: "You are not enrolled in this course" }, status: :forbidden
        end
      end
    end
  end
end
