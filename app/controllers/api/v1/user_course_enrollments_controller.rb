module Api
  module V1
    class UserCourseEnrollmentsController < ApplicationController
      before_action :authenticate_user

      def index
        enrollments = current_user.user_course_enrollments.includes(:course)
        data = enrollments.map do |enrollment|
        enrollment.recalculate_progress!
          {
            course: {
              id: enrollment.course.id,
              title: enrollment.course.title,
              description: enrollment.course.description
            },
            status: enrollment.status,
            progress: enrollment.progress,
            enrolled_at: enrollment.created_at
          }
        end
        render json: data
      end

      def create
        course = Course.find(params[:course_id])
        enrollment = current_user.user_course_enrollments.find_or_initialize_by(course: course)

        enrollment.status = :in_progress
        enrollment.progress = 0

        if enrollment.save
          render json: {
            course_id: course.id,
            status: enrollment.status,
            progress: enrollment.progress
          }, status: :created
        else
          render json: { errors: enrollment.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def show
        enrollment = current_user.user_course_enrollments
          .includes(course: { course_modules: { lessons: :lesson_assessment }, final_assessment: {} })
          .find_by(course_id: params[:id])

        unless enrollment
          return render json: { error: "You are not enrolled in this course" }, status: :not_found
        end
        enrollment.recalculate_progress!
        modules_data = enrollment.course.course_modules.map do |course_module|
          {
            title: course_module.title,
            description: course_module.description,
            position: course_module.position,
            lessons: course_module.lessons.map do |lesson|
              user_lesson_status = lesson.user_lesson_statuses.find_by(user: current_user) || UserLessonStatus.new(status: :not_started)
              lesson_assessment = lesson.lesson_assessment
              user_assessment_result = current_user.user_assessment_results.find_by(assessment: lesson_assessment) if lesson_assessment

              {
                id: lesson.id,
                title: lesson.title,
                description: lesson.description,
                position: lesson.position,
                status: user_lesson_status.status,
                assessment_score: user_assessment_result&.score,
                assessment_attempted_at: user_assessment_result&.attempted_at
              }
            end
          }
        end

        final_assessment = enrollment.course.final_assessment
        final_result = current_user.user_assessment_results.find_by(assessment: final_assessment) if final_assessment

        render json: {
          course: {
            id: enrollment.course.id,
            title: enrollment.course.title,
            description: enrollment.course.description
          },
          status: enrollment.status,
          progress: enrollment.progress,
          modules: modules_data,
          final_assessment_score: final_result&.score,
          final_assessment_attempted_at: final_result&.attempted_at
        }
      end
    end
  end
end
