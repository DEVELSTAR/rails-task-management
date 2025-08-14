FactoryBot.define do
  factory :course_module do
    sequence(:title) { |n| "Module #{n}" }
    description { "Module description" }
    sequence(:position) { |n| n }
    association :course

    trait :with_lessons_and_assessments do
      after(:create) do |mod|
        create_list(:lesson, 2, :with_contents_and_assessment, course_module: mod)
      end
    end
  end
end
