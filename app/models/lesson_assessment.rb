class LessonAssessment < ApplicationRecord
  belongs_to :lesson
  has_many :assessment_questions, dependent: :destroy
  accepts_nested_attributes_for :assessment_questions, allow_destroy: true

  validates :title, presence: true

  def self.ransackable_associations(auth_object = nil)
    ["lesson", "assessment_questions"]
  end
end
