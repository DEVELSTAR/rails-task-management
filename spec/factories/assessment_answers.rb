# spec/factories/assessment_answers.rb
FactoryBot.define do
  factory :assessment_answer do
    answer_text { "An object-oriented programming language" }
    is_correct { true }
    assessment_question
  end
end
