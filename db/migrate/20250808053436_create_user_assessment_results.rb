class CreateUserAssessmentResults < ActiveRecord::Migration[8.0]
  def change
    create_table :user_assessment_results do |t|
      t.references :user, null: false, foreign_key: true
      t.references :lesson_assessment, null: false, foreign_key: true
      t.references :final_assessment, null: false, foreign_key: true
      t.integer :score, default: 0
      t.boolean :passed
      t.datetime :attempted_at
      t.jsonb :answers

      t.timestamps
    end
  end
end
