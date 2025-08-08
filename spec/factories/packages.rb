FactoryBot.define do
  factory :package do
    title { "MyString" }
    description { "MyText" }
    price { "9.99" }
    discount { "9.99" }
    duration { 1 }
    image { "MyString" }
  end
end
