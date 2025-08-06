class AddLanguageToQuranVerses < ActiveRecord::Migration[8.0]
  def change
    add_column :quran_verses, :language, :string
  end
end
