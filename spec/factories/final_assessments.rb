FactoryBot.define do
  factory :final_assessment, class: "Assessment" do
    title        { "Final Assessment" }
    instructions { "Complete all final questions" }
    association :assessable, factory: :course

    trait :with_questions_and_answers do
      after(:create) do |assessment|
        create_list(:assessment_question, 2, :with_answers, assessment: assessment)
      end
    end
  end
end
