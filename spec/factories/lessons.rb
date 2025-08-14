FactoryBot.define do
  factory :lesson do
    sequence(:title) { |n| "Lesson #{n}" }
    description { "Lesson description" }
    sequence(:position) { |n| n }
    association :course_module

    trait :with_contents_and_assessment do
      after(:create) do |lesson|
        create_list(:lesson_content, 2, lesson: lesson)
        create(:lesson_assessment, :with_questions_and_answers, assessable: lesson)
      end
    end
  end
end
