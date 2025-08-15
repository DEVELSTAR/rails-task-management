# app/models/assessment_question.rb
class AssessmentQuestion < ApplicationRecord
  belongs_to :assessment
  has_many :assessment_answers, dependent: :destroy
  accepts_nested_attributes_for :assessment_answers, allow_destroy: true

  validates :question_text, presence: true

  def self.ransackable_associations(auth_object = nil)
    ["assessment", "assessment_answers"]
  end

  def correct_answer
    assessment_answers.detect(&:is_correct)
  end
end
