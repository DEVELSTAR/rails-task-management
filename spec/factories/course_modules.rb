FactoryBot.define do
  factory :course_module do
    title { "MyString" }
    description { "MyText" }
    position { 1 }
    course { nil }
  end
end
