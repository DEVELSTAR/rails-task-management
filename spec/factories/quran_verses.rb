# spec/factories/quran_verses.rb
FactoryBot.define do
  factory :quran_verse do
    surah_name { "Al-Fatiha" }
    verse_number { rand(1..7) }
    language { "en.asad" }
    text { "In the name of Allah..." }
  end
end
