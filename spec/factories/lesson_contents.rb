FactoryBot.define do
  factory :lesson_content do
    lesson { nil }
    content_type { 1 }
    content_data { "" }
    position { 1 }
  end
end
