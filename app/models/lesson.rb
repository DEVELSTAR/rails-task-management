class Lesson < ApplicationRecord
  belongs_to :course_module, optional: true

  has_many :lesson_contents, -> { order(:position) }, dependent: :destroy
  has_one :lesson_assessment, -> { where(assessable_type: 'Lesson') },
          class_name: 'Assessment', as: :assessable, dependent: :destroy
  has_many :user_lesson_statuses, dependent: :destroy
  has_many :users, through: :user_lesson_statuses

  accepts_nested_attributes_for :lesson_contents, allow_destroy: true
  accepts_nested_attributes_for :lesson_assessment, allow_destroy: true
  validates :title, :position, presence: true

  def self.ransackable_associations(auth_object = nil)
    ["course_module", "lesson_assessment", "user_lesson_statuses", "users"]
  end
end
