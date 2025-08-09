# app/models/address.rb
class Address < ApplicationRecord
  belongs_to :user

  validates :line1, :city, :state, :zip, :country, presence: true
end
