class CreatePackages < ActiveRecord::Migration[8.0]
  def change
    create_table :packages do |t|
      t.string :title
      t.text :description
      t.decimal :price
      t.decimal :discount
      t.integer :duration

      t.timestamps
    end
  end
end
