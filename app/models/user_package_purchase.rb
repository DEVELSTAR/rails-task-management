class UserPackagePurchase < ApplicationRecord
  belongs_to :user
  belongs_to :package

  enum :status, { active: 0, expired: 1, cancelled: 2 }

  validates :purchased_at, :expires_at, :status, presence: true

  def self.ransackable_associations(auth_object = nil)
    ["user", "package"]
  end
end
