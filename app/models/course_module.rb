class CourseModule < ApplicationRecord
  belongs_to :course, counter_cache: true
  has_many :lessons, dependent: :destroy

  # validates :title, :position, presence: true
  accepts_nested_attributes_for :lessons, allow_destroy: true

  def self.ransackable_associations(auth_object = nil)
    ["course", "lessons"]
  end
end
