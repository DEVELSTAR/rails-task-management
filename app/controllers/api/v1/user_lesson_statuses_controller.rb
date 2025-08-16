module Api
  module V1
    class UserLessonStatusesController < ApplicationController
      before_action :authenticate_user

      def update
        lesson = Lesson.includes(course_module: :course).find(params[:id])
        course = lesson.course
        enrollment = current_user.user_course_enrollments.find_by(course: course)

        return render json: { error: "You are not enrolled in this course" }, status: :forbidden unless enrollment

        unless UserLessonStatus.statuses.key?(params[:status])
          return render json: { errors: ["Invalid status"] }, status: :unprocessable_entity
        end

        user_lesson_status = current_user.user_lesson_statuses.find_or_initialize_by(lesson: lesson)
        user_lesson_status.status = params[:status]

        if user_lesson_status.save
          enrollment.recalculate_progress!
          render json: {
            course_id: course.id,
            lesson_id: lesson.id,
            status: user_lesson_status.status,
            progress: enrollment.progress
          }
        else
          render json: { errors: user_lesson_status.errors.full_messages }, status: :unprocessable_entity
        end
      end
    end
  end
end
