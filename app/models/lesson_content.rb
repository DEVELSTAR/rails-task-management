class LessonContent < ApplicationRecord
  belongs_to :lesson

  enum :content_type, {
    paragraph: 0,
    video: 1,
    image: 2,
    bullet_point: 3,
    mcq: 4,
    code: 5
  }

  validates :content_type, :content_data, :position, presence: true

  def self.ransackable_associations(auth_object = nil)
    ["lesson"]
  end
end
