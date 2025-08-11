class Course < ApplicationRecord
  has_many :course_modules, dependent: :destroy
  has_many :lessons, through: :course_modules
  has_many :user_course_enrollments, dependent: :destroy
  has_many :enrolled_users, through: :user_course_enrollments, source: :user
  has_many :assessments, as: :assessable, dependent: :destroy
  has_one :final_assessment, -> { where(assessable_type: "Course") },
          class_name: "Assessment", as: :assessable, dependent: :destroy
  has_one_attached :thumbnail
  accepts_nested_attributes_for :course_modules, allow_destroy: true
  accepts_nested_attributes_for :final_assessment, allow_destroy: true

  enum :status, { draft: 0, published: 1 }
  enum :level, { beginner: 0, intermediate: 1, advanced: 2 }

  validates :title, :slug, :description, presence: true
  validates :slug, uniqueness: true

  def self.ransackable_associations(auth_object = nil)
    ["course_modules", "enrolled_users", "user_course_enrollments", "final_assessment", "lessons", "assessments"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "description", "duration", "id", "language", "level", "price", "slug", "status", "title", "updated_at", "thumbnail_attachment_id_eq", "thumbnail_blob_id_eq", "thumbnail_attachment_id_eq", "thumbnail_blob_id_eq"]
  end
end
