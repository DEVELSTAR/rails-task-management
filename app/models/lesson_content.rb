class LessonContent < ApplicationRecord
  belongs_to :lesson
  has_one_attached :video
  has_one_attached :image

  enum :content_type, {
    text: 0,
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

  def self.ransackable_attributes(auth_object = nil)
    ["video_attachment_id_eq", "video_blob_id_eq", "image_attachment_id_eq", "image_blob_id_eq"]
  end
end
