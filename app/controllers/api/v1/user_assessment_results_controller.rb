module Api
  module V1
    class UserAssessmentResultsController < ApplicationController
      before_action :authenticate_user

      def create
        assessment = Assessment.find(params[:id])
        assessable = assessment.assessable
        course = if assessable.is_a?(Lesson)
                  assessable.course_module.course
        elsif assessable.is_a?(Course)
                  assessable
        else
                  nil
        end

        enrollment = current_user.user_course_enrollments.find_by(course: course) if course

        if enrollment
          # Expect params[:answers] to be an array of { question_id: id, answer_id: id }
          answers = params[:answers] || []
          if answers.blank?
            return render json: { errors: ["Answers are required"] }, status: :unprocessable_content
          end

          questions = assessment.assessment_questions.includes(:assessment_answers)
          if questions.empty?
            return render json: { errors: ["No questions found for this assessment"] }, status: :unprocessable_content
          end

          # Calculate score
          correct_count = 0
          answers.each do |answer|
            question = questions.find { |q| q.id == answer["question_id"].to_i }
            correct_answer = question&.correct_answer
            if correct_answer && correct_answer.id == answer[:answer_id].to_i
              correct_count += 1
            end
          end
          score = ((correct_count.to_f / questions.count) * 100).round

          # Find or initialize result for this user & assessment
          result = current_user.user_assessment_results.find_or_initialize_by(assessment: assessment)

          # Update score and attempt time
          result.score = score
          result.attempted_at = Time.current

          if result.save
            enrollment.recalculate_progress!
            render json: {
              assessment_id: assessment.id,
              score: result.score,
              attempted_at: result.attempted_at,
              re_attempted_at: result.updated_at
            }, status: result.previously_new_record? ? :created : :ok
          else
            render json: { errors: result.errors.full_messages }, status: :unprocessable_content
          end
        else
          render json: { error: "You are not enrolled in this course or cannot attempt this assessment" }, status: :forbidden
        end
      end
    end
  end
end
