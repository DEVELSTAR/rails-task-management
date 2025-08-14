 # spec/factories/courses.rb
 FactoryBot.define do
  factory :course do
    title       { "Ruby Basics" }
    description { "Learn the fundamentals of Ruby" }
    duration    { "5 hours" }
    sequence(:slug) { |n| "ruby-basics-#{n}" }
    price       { 49.99 }
    status      { "draft" }
    level       { "beginner" }
    language    { "English" }

    trait :with_thumbnail do
      after(:create) do |course|
        course.thumbnail.attach(
          io: File.open(Rails.root.join("spec", "support", "assets", "thumbnail.png")),
          filename: "thumbnail.png",
          content_type: "image/png"
        )
      end
    end

    trait :with_full_structure do
      after(:create) do |course|
        create_list(:course_module, 2, :with_lessons_and_assessments, course: course)
        create(:final_assessment, :with_questions_and_answers, assessable: course)
      end
    end
  end
end
