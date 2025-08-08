class UserCourseEnrollment < ApplicationRecord
  belongs_to :user
  belongs_to :course

  enum :status, {
    in_progress: 0,
    completed: 1,
    expired: 2
  }

  validates :status, presence: true
  validates :progress, numericality: { in: 0..100 }

  def self.ransackable_associations(auth_object = nil)
    ["user", "course"]
  end
end
