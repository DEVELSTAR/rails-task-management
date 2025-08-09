class UserAssessmentResult < ApplicationRecord
  belongs_to :user
  belongs_to :assessment

  validates :score, :attempted_at, presence: true

  def self.ransackable_associations(auth_object = nil)
    ["user", "lesson_assessment", "final_assessment"]
  end
end
