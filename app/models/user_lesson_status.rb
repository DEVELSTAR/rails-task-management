class UserLessonStatus < ApplicationRecord
  belongs_to :user
  belongs_to :lesson

  enum :status, {
    not_started: 0,
    in_progress: 1,
    completed: 2
  }

  validates :status, presence: true

  def self.ransackable_associations(auth_object = nil)
    ["user", "lesson"]
  end
end
