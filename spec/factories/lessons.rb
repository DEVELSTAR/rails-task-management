FactoryBot.define do
  factory :lesson do
    title { "MyString" }
    description { "MyText" }
    position { 1 }
    course { nil }
    course_module { nil }
  end
end
