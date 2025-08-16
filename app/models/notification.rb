class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :course, optional: true

  enum :notification_type, { reminder: 0, system: 1, info: 2 }

  validates :message, presence: true

  scope :unread, -> { where(read_at: nil) }
  scope :read, -> { where.not(read_at: nil) }

  def mark_as_read!
    update!(read_at: Time.current)
  end

  def mark_as_unread!
    update!(read_at: nil)
  end

  def read?
    read_at.present?
  end
end
