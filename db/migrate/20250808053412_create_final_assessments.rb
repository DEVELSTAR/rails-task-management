class CreateFinalAssessments < ActiveRecord::Migration[8.0]
  def change
    create_table :final_assessments do |t|
      t.references :course, null: false, foreign_key: true
      t.string :title
      t.text :instructions

      t.timestamps
    end
  end
end
