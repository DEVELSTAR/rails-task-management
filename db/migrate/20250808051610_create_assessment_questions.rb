class CreateAssessmentQuestions < ActiveRecord::Migration[8.0]
  def change
    create_table :assessment_questions do |t|
      t.references :lesson_assessment, null: false, foreign_key: true
      t.text :question_text
      t.jsonb :options
      t.string :correct_option
      t.text :explanation

      t.timestamps
    end
  end
end
