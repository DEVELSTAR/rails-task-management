class AddFinalAssessmentToAssessmentQuestions < ActiveRecord::Migration[8.0]
  def change
    add_reference :assessment_questions, :final_assessment, foreign_key: true
  end
end
