# app/models/admin_user.rb
class AdminUser < ApplicationRecord
  has_secure_password
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }
end
