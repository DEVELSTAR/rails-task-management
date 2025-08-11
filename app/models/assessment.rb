class Assessment < ApplicationRecord
  belongs_to :assessable, polymorphic: true
  has_many :assessment_questions, dependent: :destroy
  has_many :user_assessment_results, dependent: :destroy

  accepts_nested_attributes_for :assessment_questions, allow_destroy: true

  validates :title, presence: true

  def self.ransackable_associations(auth_object = nil)
    ["course", "assessment_questions"]
  end
end
