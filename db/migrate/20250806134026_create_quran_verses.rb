class CreateQuranVerses < ActiveRecord::Migration[8.0]
  def change
    create_table :quran_verses do |t|
      t.string :surah_name
      t.string :verse_number
      t.text :text
      t.string :source

      t.timestamps
    end
  end
end
