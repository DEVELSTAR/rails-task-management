class Package < ApplicationRecord
  has_many :course_packages, dependent: :destroy
  has_many :courses, through: :course_packages
  has_one_attached :thumbnail
  has_many :user_package_purchases, dependent: :destroy
  has_many :users, through: :user_package_purchases

  validates :title, :description, :price, :discount, :duration, presence: true
  def self.ransackable_associations(auth_object = nil)
    ["course_packages", "courses", "user_package_purchases", "users", "thumbnail"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["id", "title", "description", "price", "discount", "duration", "image", "thumbnail_attachment_id_eq", "thumbnail_blob_id_eq", "created_at", "updated_at"]
  end
end
