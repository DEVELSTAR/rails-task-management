FactoryBot.define do
  factory :user_course_enrollment do
    user { nil }
    course { nil }
    status { 1 }
    progress { 1 }
    enrolled_at { "2025-08-08 11:02:42" }
    completed_at { "2025-08-08 11:02:42" }
  end
end
