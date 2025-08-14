FactoryBot.define do
  factory :lesson_content do
    content_type { "text" }
    sequence(:content_data) { |n| "Content data #{n}" }
    sequence(:position) { |n| n }
    association :lesson
  end
end
