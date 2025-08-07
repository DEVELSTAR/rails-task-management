# app/models/user.rb
class User < ApplicationRecord
  has_secure_password
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }
  has_many :tasks, dependent: :destroy

  def to_s
    email
  end
end
