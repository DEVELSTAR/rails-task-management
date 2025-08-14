FactoryBot.define do
  factory :assessment_answer do
    answer_text { "Answer text" }
    is_correct  { false }
    association :assessment_question
  end
end
