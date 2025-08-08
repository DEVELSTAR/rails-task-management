class AssessmentQuestion < ApplicationRecord
  belongs_to :lesson_assessment, optional: true
  belongs_to :final_assessment, optional: true

  validates :question_text, :options, :correct_option, presence: true
  
  def self.ransackable_associations(auth_object = nil)
    ["lesson_assessment", "final_assessment"]
  end
end
