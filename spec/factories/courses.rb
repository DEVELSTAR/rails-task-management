FactoryBot.define do
  factory :course do
    title { "MyString" }
    description { "MyText" }
    duration { 1 }
    slug { "MyString" }
    image { "MyString" }
    price { "9.99" }
    status { 1 }
    language { "MyString" }
    level { 1 }
  end
end
