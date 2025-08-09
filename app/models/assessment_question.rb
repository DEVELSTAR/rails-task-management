class AssessmentQuestion < ApplicationRecord
  belongs_to :assessment

  validates :question_text, :options, :correct_option, presence: true

  def self.ransackable_associations(auth_object = nil)
    ["lesson_assessment", "final_assessment"]
  end
end
