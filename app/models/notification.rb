# frozen_string_literal: true

class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :notifiable, polymorphic: true

  validates :description, presence: true, length: { minimum: 5, maximum: 255 }
  validates :status, presence: true
  validates :user_id, presence: true

  enum notification_status: { new_notification: "new_notification", read: "read", archived: "archived" }, _prefix: :status, _default: "new_notification"
end
