FactoryBot.define do
  factory :user_assessment_result do
    user { nil }
    lesson_assessment { nil }
    final_assessment { nil }
    score { 1 }
    passed { false }
    attempted_at { "2025-08-08 11:04:37" }
    answers { "" }
  end
end
# FactoryBot.define do
#   factory :user_assessment_result do
#     association :user
#     association :assessment
#     score { 0 }
#     attempted_at { nil }
#   end
# end