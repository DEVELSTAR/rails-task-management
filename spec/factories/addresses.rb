FactoryBot.define do
  factory :address do
    user { nil }
    line1 { "MyString" }
    line2 { "MyString" }
    city { "MyString" }
    state { "MyString" }
    zip { "MyString" }
    country { "MyString" }
  end
end
