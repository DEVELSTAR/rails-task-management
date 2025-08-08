FactoryBot.define do
  factory :user_lesson_status do
    user { nil }
    lesson { nil }
    status { 1 }
    score { 1 }
    completed_at { "2025-08-08 10:50:20" }
  end
end
