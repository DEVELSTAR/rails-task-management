FactoryBot.define do
  factory :lesson_assessment, class: "Assessment" do
    title        { "Lesson Assessment" }
    instructions { "Answer all questions" }
    association :assessable, factory: :lesson

    trait :with_questions_and_answers do
      after(:create) do |assessment|
        create_list(:assessment_question, 2, :with_answers, assessment: assessment)
      end
    end
  end
end
