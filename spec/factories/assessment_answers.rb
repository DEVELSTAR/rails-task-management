# spec/factories/assessment_answers.rb
FactoryBot.define do
  factory :assessment_answer do
    answer_text { "An object-oriented programming language" }
    is_correct { true }
    assessment_question

    trait :correct do
      is_correct { true }
    end

    trait :incorrect do
      is_correct { false }
    end
  end
end
