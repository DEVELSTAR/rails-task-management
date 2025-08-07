class QuranVerse < ApplicationRecord
  def self.ransackable_attributes(auth_object = nil)
    [ "created_at", "id", "source", "surah_name", "text", "updated_at", "verse_number", "language" ]
  end
end
