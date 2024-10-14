# frozen_string_literal: true

# spec/models/notification_spec.rb

require "rails_helper"

RSpec.describe Notification, type: :model do
  fixtures :users, :order_items

  describe "associations" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:notifiable) }
  end

  # Test validations
  describe "validations" do
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_length_of(:description).is_at_least(5).is_at_most(255) }
    it { is_expected.to validate_presence_of(:status) }
    it { is_expected.to validate_presence_of(:user_id) }
  end

  # Test enum values
  describe "enums" do
    let(:notification) { Notification.new }

    it "responds to enum methods" do
      expect(notification).to respond_to(:status_new_notification?)
      expect(notification).to respond_to(:status_read?)
      expect(notification).to respond_to(:status_archived?)
      expect(notification).to respond_to(:status_new_notification!)
      expect(notification).to respond_to(:status_read!)
      expect(notification).to respond_to(:status_archived!)
    end

    it "has new_notification as the default value for notification_status" do
      expect(notification.notification_status).to eq("new_notification")
    end

    it "can change the notification_status" do
      user = users(:standard_user_one)
      order_item = order_items(:pending_order_item_one)
      notification = user.notifications.create(description: "Test notification", status: "new_notification", notifiable: order_item)
      notification.status_read!
      expect(notification.notification_status).to eq("read")
      expect(notification).to be_status_read
    end
  end
end
