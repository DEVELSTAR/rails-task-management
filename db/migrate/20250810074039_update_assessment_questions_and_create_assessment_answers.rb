# db/migrate/YYYYMMDDHHMMSS_update_assessment_questions_and_create_assessment_answers.rb
class UpdateAssessmentQuestionsAndCreateAssessmentAnswers < ActiveRecord::Migration[7.0]
  def change
    # Update assessment_questions
    remove_column :assessment_questions, :options, :jsonb
    remove_column :assessment_questions, :correct_option, :string

    # Create assessment_answers
    create_table :assessment_answers do |t|
      t.references :assessment_question, null: false, foreign_key: true
      t.text :answer_text, null: false
      t.boolean :is_correct, default: false, null: false
      t.timestamps
    end
  end
end
