class Task < ApplicationRecord
  validates :title, presence: true, length: { minimum: 3, maximum: 100 }
  validates :description, length: { maximum: 500 }, allow_blank: true
  validate :title_cannot_start_with_draft
  validates :status, inclusion: { in: %w(todo in_progress done) }
  belongs_to :user

  private

  def title_cannot_start_with_draft
    if title&.downcase&.start_with?("draft:")
      errors.add(:title, "cannot start with 'DRAFT:'")
    end
  end
end