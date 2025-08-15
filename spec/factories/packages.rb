# spec/factories/packages.rb
FactoryBot.define do
  factory :package do
    title { "Sample Package" }
    description { "A description of the package" }
    price { 49.99 }
    discount { 5 }
    duration { 30 }

    transient do
      courses_count { 0 }
    end

    after(:build) do |package|
      unless package.thumbnail.attached?
        package.thumbnail.attach(
          io: File.open(Rails.root.join("spec/support/assets/thumbnail.png")),
          filename: "thumbnail.png",
          content_type: "image/png"
        )
      end
    end

    after(:create) do |package, evaluator|
      if evaluator.courses_count > 0
        courses = create_list(:course, evaluator.courses_count)
        package.courses << courses
      end
    end
  end
end
