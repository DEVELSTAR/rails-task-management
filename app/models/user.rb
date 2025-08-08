# app/models/user.rb
class User < ApplicationRecord
  has_secure_password
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }
  has_many :tasks, dependent: :destroy
  has_many :user_lesson_statuses, dependent: :destroy
  has_many :lessons, through: :user_lesson_statuses
  has_many :user_course_enrollments, dependent: :destroy
  has_many :enrolled_courses, through: :user_course_enrollments, source: :course
  has_many :user_assessment_results, dependent: :destroy
  has_many :user_package_purchases, dependent: :destroy
  has_many :packages, through: :user_package_purchases
  
  def self.ransackable_associations(auth_object = nil)
    ["tasks", "user_lesson_statuses", "lessons", "user_course_enrollments", "enrolled_courses", "user_assessment_results", "user_package_purchases", "packages"]
  end

  def to_s
    email
  end
end
