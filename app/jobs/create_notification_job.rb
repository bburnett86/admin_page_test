class CreateNotificationJob < ApplicationJob
  queue_as :default

  def perform(user:, notifiable:, description:, status:)
    Notification.create!(
      creator: user,
      notifiable: notifiable,
      description: description,
      status: status
    )
  end
end