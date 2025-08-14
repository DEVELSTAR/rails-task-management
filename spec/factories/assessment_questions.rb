# spec/factories/assessment_questions.rb
FactoryBot.define do
  factory :assessment_question do
    sequence(:question_text) { |n| "Question #{n}" }
    explanation { "Explanation" }
    association :assessment

    trait :with_answers do
      after(:create) do |question|
        create(:assessment_answer, answer_text: "Correct Answer", is_correct: true, assessment_question: question)
        create(:assessment_answer, answer_text: "Wrong Answer", is_correct: false, assessment_question: question)
      end
    end
  end
end
