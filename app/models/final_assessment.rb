class FinalAssessment < ApplicationRecord
  belongs_to :course
  has_many :assessment_questions, dependent: :destroy
  accepts_nested_attributes_for :assessment_questions, allow_destroy: true

  def self.ransackable_associations(auth_object = nil)
    ["course", "assessment_questions"]
  end
end
