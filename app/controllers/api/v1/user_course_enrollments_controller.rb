module Api
  module V1
    class UserCourseEnrollmentsController < ApplicationController
      before_action :authenticate_user
      before_action :set_enrollment, only: [:destroy]

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

      def destroy
        if params[:reset_progress] == "true"
          reset_progress(@enrollment)
        end

        if @enrollment.destroy
          render json: { message: "Unenrolled successfully#{' and progress reset' if params[:reset_progress] == 'true'}." }
        else
          render json: { error: "Unable to unenroll." }, status: :unprocessable_content
        end
      end

      def create
        course = Course.find(params[:course_id])
        if current_user.user_course_enrollments.find_by(course: course)
          return render json: { message: "You are already enrolled in this course!" }, status: :ok
        end

        enrollment = current_user.user_course_enrollments.new(course: course)

        enrollment.status = :in_progress
        enrollment.progress = 0

        if enrollment.save
          create_notification(current_user, course, :enrolled)
          render json: {
            course_id: course.id,
            status: enrollment.status,
            progress: enrollment.progress
          }, status: :created
        else
          render json: { errors: enrollment.errors.full_messages }, status: :unprocessable_content
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

      private

      def set_enrollment
        @enrollment = current_user.user_course_enrollments.find_by(course_id: params[:id])
        render json: { error: "Enrollment not found." }, status: :not_found unless @enrollment
      end

      def reset_progress(enrollment)
        course = enrollment.course

        # Wipe lesson progress
        lesson_ids = course.course_modules.joins(:lessons).pluck("lessons.id")
        current_user.user_lesson_statuses.where(lesson_id: lesson_ids).delete_all

        # Wipe assessment results
        assessment_ids = Assessment
          .where(assessable_type: "Lesson", assessable_id: lesson_ids)
          .pluck(:id)
        assessment_ids << course.final_assessment_id if course.final_assessment_id.present?
        current_user.user_assessment_results.where(assessment_id: assessment_ids).delete_all
      end
    end
  end
end
