FactoryBot.define do
  factory :assessment_question do
    lesson_assessment { nil }
    question_text { "MyText" }
    options { "" }
    correct_option { "MyString" }
    explanation { "MyText" }
  end
end
