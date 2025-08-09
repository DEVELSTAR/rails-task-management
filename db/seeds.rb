# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# db/seeds.rb
require 'faker' # For generating random data

# user = User.first
# 10.times do
# user.tasks.create!(
#     title: Faker::Lorem.sentence(word_count: 3),
#     description: Faker::Lorem.paragraph,
#     status: %w[todo in_progress done].sample,
#     due_date: Faker::Date.forward(days: 30)
# )
# end

# puts "Seeded #{Task.count} tasks!"


# Clear existing data (for clean seeding during development)
# LessonContent.destroy_all
# AssessmentQuestion.destroy_all
# LessonAssessment.destroy_all
# Lesson.destroy_all
# CourseModule.destroy_all
# Course.destroy_all
# User.destroy_all

# # Create an admin user (optional)
# User.create!(
#   email: "admin@example.com",
#   password: "password"
# )

# Create a Course
# course = Course.create!(
#   title: "Ruby on Rails for Beginners",
#   description: "Learn Rails step-by-step with real examples.",
#   duration: 10,
#   slug: "rails-for-beginners",
#   image: "rails-course.png",
#   price: 999.0,
#   status: :published,
#   level: :beginner,
#   language: "English",
# )

# # Create Modules
# module1 = CourseModule.create!(title: "Getting Started", description: "Basics of Rails", position: 1, course: course)
# module2 = CourseModule.create!(title: "Models and Migrations", description: "Understanding models", position: 2, course: course)

# # Create Lessons under each module
# [["Intro to Rails", "Welcome to Rails!"], ["Installing Rails", "Installation guide"]].each_with_index do |(title, desc), index|
#   lesson = Lesson.create!(
#     title: title,
#     description: desc,
#     position: index + 1,
#     course: course,
#     course_module: module1
#   )

#   # Lesson contents
#   LessonContent.create!(
#     lesson: lesson,
#     content_type: :paragraph,
#     content_data: { text: "This is a sample paragraph for #{title}" },
#     position: 1
#   )

#   LessonContent.create!(
#     lesson: lesson,
#     content_type: :video,
#     content_data: { url: "https://www.youtube.com/watch?v=123456", duration: "5:00" },
#     position: 2
#   )

#   # Lesson assessment
#   assessment = LessonAssessment.create!(
#     lesson: lesson,
#     title: "Quiz for #{title}",
#     instructions: "Answer all questions"
#   )

#   AssessmentQuestion.create!(
#     lesson_assessment: assessment,
#     question_text: "What is Rails?",
#     options: ["A gem", "A framework", "A car", "A tool"],
#     correct_option: "B",
#     explanation: "Rails is a web application framework written in Ruby."
#   )
# end

# Repeat for module 2
# [["Creating Models", "Using generators"], ["Understanding Migrations", "DB structure"]].each_with_index do |(title, desc), index|
#   lesson = Lesson.create!(
#     title: title,
#     description: desc,
#     position: index + 1,
#     course: course,
#     course_module: module2
#   )

#   LessonContent.create!(
#     lesson: lesson,
#     content_type: :paragraph,
#     content_data: { text: "Model details for #{title}" },
#     position: 1
#   )

#   LessonContent.create!(
#     lesson: lesson,
#     content_type: :video,
#     content_data: { url: "https://www.youtube.com/watch?v=abcdef", duration: "4:20" },
#     position: 2
#   )

#   assessment = LessonAssessment.create!(
#     lesson: lesson,
#     title: "Quiz for #{title}",
#     instructions: "Complete the quiz"
#   )

#   AssessmentQuestion.create!(
#     lesson_assessment: assessment,
#     question_text: "What does a migration do?",
#     options: ["Create routes", "Modify DB schema", "Render views", "Send emails"],
#     correct_option: "B",
#     explanation: "Migrations define DB schema changes."
#   )
# end

# puts "✅ Seeded course, modules, lessons, contents, and assessments!"
