class Package < ApplicationRecord
  has_many :course_packages, dependent: :destroy
  has_many :courses, through: :course_packages

  has_many :user_package_purchases, dependent: :destroy
  has_many :users, through: :user_package_purchases

  def self.ransackable_associations(auth_object = nil)
    ["course_packages", "courses", "user_package_purchases", "users"]
  end
end
