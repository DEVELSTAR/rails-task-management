# spec/factories/assessments.rb
FactoryBot.define do
  factory :assessment do
    title { "Assessment" }
    instructions { "Answer the questions" }

    trait :with_questions_and_answers do
      after(:create) do |assessment|
        create_list(:assessment_question, 2, :with_answers, assessment: assessment)
      end
    end
  end
end
