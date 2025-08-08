class CourseModule < ApplicationRecord
  belongs_to :course
  has_many :lessons, dependent: :destroy

  validates :title, :position, presence: true
  
  def self.ransackable_associations(auth_object = nil)
    ["course", "lessons"]
  end
end
