class CreateCatFacts < ActiveRecord::Migration[8.0]
  def change
    create_table :cat_facts do |t|
      t.string :fact, null: false
      t.string :source, default: "catfact.ninja"
      t.timestamps
    end
  end
end
