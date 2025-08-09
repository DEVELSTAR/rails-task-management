class CreateAssessments < ActiveRecord::Migration[8.0]
  def change
    create_table :assessments do |t|
      t.references :assessable, polymorphic: true, null: false  # Course or Lesson
      t.string :title
      t.text :instructions
      t.timestamps
    end
  end
end
