class UserAssessmentResult < ApplicationRecord
  belongs_to :user
  belongs_to :lesson_assessment, optional: true
  belongs_to :final_assessment, optional: true

  validates :score, :attempted_at, presence: true

  def self.ransackable_associations(auth_object = nil)
    ["user", "lesson_assessment", "final_assessment"]
  end
end
