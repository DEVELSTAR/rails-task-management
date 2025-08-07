# app/models/user.rb
class User < ApplicationRecord
  has_secure_password
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }
  has_many :tasks, dependent: :destroy

  def self.ransackable_attributes(auth_object = nil)
    %w[id email created_at updated_at]
  end

  def to_s
    email
  end
end
