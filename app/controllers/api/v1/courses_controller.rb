module Api
  module V1
    class CoursesController < ApplicationController
      before_action :set_course, only: [:show]

      def index
        courses = Course.includes(
          course_modules: { lessons: [:lesson_contents, { lesson_assessment: :assessment_questions }] },
          final_assessment: :assessment_questions
        )

        render json: courses.map { |course| CourseSerializer.new(course).as_json }
      end

      def show
        course = Course.find(params[:id])
        render json: CourseSerializer.new(course, { params: { host: request.base_url } }).serializable_hash
      end

      def create
        course = Course.new(course_params)
        if course.save
          render json: CourseSerializer.new(course), status: :created
        else
          render json: { errors: course.errors.full_messages }, status: :unprocessable_content
        end
      end

      private

      def set_course
        @course = Course.includes(
          course_modules: { lessons: [:lesson_contents, { lesson_assessment: :assessment_questions }] },
          final_assessment: :assessment_questions
        ).find(params[:id])
      end

      def course_params
        params.require(:course).permit(
          :title, :description, :duration, :slug, :thumbnail, :price, :status, :level, :language,
          course_modules_attributes: [
            :id, :title, :description, :position, :_destroy,
            lessons_attributes: [
              :id, :title, :description, :position, :course_module_id, :_destroy,
              lesson_contents_attributes: [:id, :content_type, :image, :video, :position, :content_data, :_destroy],
              lesson_assessment_attributes: [
                :id, :title, :instructions, :_destroy,
                assessment_questions_attributes: [
                  :id, :question_text, :explanation, :_destroy,
                  assessment_answers_attributes: [:id, :answer_text, :is_correct, :_destroy]
                ]
              ]
            ]
          ],
          final_assessment_attributes: [
            :id, :title, :instructions, :_destroy,
            assessment_questions_attributes: [
              :id, :question_text, :explanation, :_destroy,
              assessment_answers_attributes: [:id, :answer_text, :is_correct, :_destroy]
            ]
          ]
        )
      end
    end
  end
end
