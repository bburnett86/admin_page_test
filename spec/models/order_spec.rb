# frozen_string_literal: true

# spec/models/order_spec.rb
require "rails_helper"

RSpec.describe Order, type: :model do
  fixtures :orders, :users, :products, :order_items

  describe "associations" do
    it { should belong_to(:user) }
    it { should have_many(:order_items) }
    it { should have_many(:products).through(:order_items) }
  end

  describe "validations" do
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:status) }
    it {
      should define_enum_for(:status).with_values(add_to_cart: "add_to_cart", shopping_cart: "shopping_cart", payment_methods: "payment_methods",
                                                  delivery_methods: "delivery_methods", confirm_order: "confirm_order", pending: "pending", processed: "processed", shipped: "shipped", cancelled: "cancelled", delivered: "delivered", returned: "returned", delayed: "delayed", returning: "returning").backed_by_column_of_type(:string)
    }
  end

  # Public Methods
  describe "#receipt" do
    it "returns a receipt with correct total and item details" do
      order = orders(:pending_order)

      receipt = order.receipt
      expect(receipt[:total]).to eq(78)
      expect(receipt[:receipt][0][:sale_price]).to eq(8.00)
      expect(receipt[:receipt][0][:original_price]).to eq(10.00)
      expect(receipt[:receipt][0][:percentage_off]).to eq(20)
    end
  end

  # Private Method Functionality
  describe "expected_delivery_date validation" do
    it "is invalid if the expected_delivery_date is before the creation date for statuses other than pending, cancelled, delivered, returned, or returning" do
      order = Order.new(expected_delivery_date: 1.day.ago, created_at: Time.zone.now, status: "processed")
      order.valid?
      expect(order.errors[:expected_delivery_date]).to include("must be after the order creation date and not blank for statuses other than pending, cancelled, delivered, returned, or returning")
    end
  end

  describe "#create_notification on order creation" do
    it "enqueues a CreateNotificationJob when a new order is created" do
      user = users(:standard_user_one)

      expect do
        Order.create(user: user, status: "pending", expected_delivery_date: 3.days.from_now)
      end.to have_enqueued_job(CreateNotificationJob)
    end
  end

  describe "Order status change notifications" do
    # Pending
    it "enqueues a job to send a pending notification with the updated description when status changes to processed" do
      order = orders(:processed_order)
      expect do
        order.update(status: "pending")
      end.to have_enqueued_job(CreateNotificationJob).with(user: order.user, notifiable: order, description: "Your order has been confirmed, you will receive more updates soon.", status: "success")
    end

    # Processed
    it "enqueues a job to send a delivered notification when status changes to delivered" do
      order = orders(:processed_order)
      expect do
        order.update(status: "delivered")
      end.to have_enqueued_job(CreateNotificationJob).with(user: order.user, notifiable: order, description: "Your order #{order.id} has been delivered", status: "success")
    end

    # Shipped
    it "enqueues a job to send a shipped notification when status changes to shipped" do
      order = orders(:pending_order)
      expect do
        order.update(status: "shipped")
      end.to have_enqueued_job(CreateNotificationJob).with(user: order.user, notifiable: order, description: "Your order #{order.id} has been shipped", status: "success")
    end

    # Delivered
    it "enqueues a job to send a delivered notification when status changes to delivered" do
      order = orders(:shipped_order)
      expect do
        order.update(status: "delivered")
      end.to have_enqueued_job(CreateNotificationJob).with(user: order.user, notifiable: order, description: "Your order #{order.id} has been delivered", status: "success")
    end

    # Cancelled
    it "enqueues a job to send a cancelled notification when status changes to cancelled" do
      order = orders(:pending_order)
      expect do
        order.update(status: "cancelled")
      end.to have_enqueued_job(CreateNotificationJob).with(user: order.user, notifiable: order, description: "Your order #{order.id} has been cancelled", status: "error")
    end

    # Returned
    it "enqueues a job to send a returned notification when status changes to returned" do
      order = orders(:returning_order)
      expect do
        order.update(status: "returned")
      end.to have_enqueued_job(CreateNotificationJob).with(user: order.user, notifiable: order, description: "Your order #{order.id} has been returned", status: "success")
    end

    # Delayed
    it "enqueues a job to send a shipped notification when status changes to shipped" do
      order = orders(:processed_order)
      expect do
        order.update(status: "shipped")
      end.to have_enqueued_job(CreateNotificationJob).with(user: order.user, notifiable: order, description: "Your order #{order.id} has been shipped", status: "success")
    end

    # Returning
    it "enqueues a job to send a returning notification when status changes to returning" do
      order = orders(:delivered_order)
      expect do
        order.update(status: "returning")
      end.to have_enqueued_job(CreateNotificationJob).with(user: order.user, notifiable: order, description: "Your order #{order.id} has been accepted for return. We will update you when it has been received.", status: "success")
    end

    # Unhandled status
    it "does not enqueue a job if notification details are nil" do
      order = orders(:processed_order)
      allow(order).to receive(:status).and_return("an_unhandled_status")
      expect do
        order.handle_status_change
      end.not_to have_enqueued_job(CreateNotificationJob)
    end
  end

  # Fixtures
  describe "fixtures" do
    it "has valid fixtures" do
      orders.each do |order|
        expect(order).to be_valid, order.errors.full_messages.join(", ")
      end
    end

    it "associates orders correctly with users" do
      expect(users(:standard_user_one).orders).to include(orders(:pending_order), orders(:processed_order), orders(:cancelled_order), orders(:delivered_order))
      expect(users(:standard_user_two).orders).to include(orders(:returned_order), orders(:delayed_order), orders(:returning_order), orders(:shipped_order))
    end

    it "associates order_items correctly with orders" do
      expect(orders(:pending_order).order_items).to match_array([order_items(:pending_order_item_one), order_items(:pending_order_item_two), order_items(:pending_order_item_three)])
      expect(orders(:processed_order).order_items).to match_array([order_items(:processed_order_item_one), order_items(:processed_order_item_two), order_items(:processed_order_item_three)])
      # Add similar checks for other orders as needed
    end
  end
end
