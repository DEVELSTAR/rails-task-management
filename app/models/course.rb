class Course < ApplicationRecord
  has_many :course_modules, dependent: :destroy
  has_many :lessons, through: :course_modules
#   has_many :lessons, dependent: :destroy
  has_many :user_course_enrollments, dependent: :destroy
  has_many :enrolled_users, through: :user_course_enrollments, source: :user

  accepts_nested_attributes_for :course_modules, allow_destroy: true
  accepts_nested_attributes_for :lessons, allow_destroy: true

 enum :status, { draft: 0, published: 1 }
 enum :level, { beginner: 0, intermediate: 1, advanced: 2 }


  validates :title, :slug, :description, presence: true
  validates :slug, uniqueness: true

  def self.ransackable_associations(auth_object = nil)
    ["course_modules", "enrolled_users", "lessons", "user_course_enrollments"]
  end
end
