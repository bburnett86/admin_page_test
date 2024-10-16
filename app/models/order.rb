# frozen_string_literal: true

class Order < ApplicationRecord
  include StatusEnum
  include OrderAnalytics
  include ChartDateGenerator

  scope :before_date, ->(end_date) { where("created_at < ?", end_date) }
  scope :by_status, ->(status) { where(status: status) }

  belongs_to :user
  has_many :order_items
  has_many :products, through: :order_items
  has_many :tickets, as: :ticketable
  has_many :notifications, as: :notifiable

  validates :user_id, presence: true
  validates :status, presence: true

  validate :expected_delivery_date_after_created_at

  after_create :send_order_created_notification
  after_update :handle_status_change, if: :saved_change_to_status?

  def receipt
    raise "No items in the order" if order_items.empty?

    receipt = []
    total = 0

    item_counts = order_items.group_by(&:product).transform_values(&:count)

    order_items.each do |item|
      quantity = item_counts[item.product]
      history = order_items.find_by(product_id: item.product_id)
      total += (quantity * history.sale_price)
      receipt.push({ name: item.product.name, quantity: quantity, sale_price: history.sale_price, original_price: history.current_price, percentage_off: history.percentage_off })
    end

    { receipt: receipt, total: total }
  end

  def handle_status_change
    notification_details =
      case status
      when "pending"
        { description: "Your order has been confirmed, you will receive more updates soon.", status: "success" }
      when "cancelled"
        { description: "Your order #{id} has been cancelled", status: "error" }
      when "returned"
        { description: "Your order #{id} has been returned", status: "success" }
      when "delayed"
        { description: "Your order #{id} has been delayed. It is now expected to arrive by #{expected_delivery_date.strftime('%Y-%m-%d')}.", status: "warning" }
      when "delivered"
        { description: "Your order #{id} has been delivered", status: "success" }
      when "shipped"
        { description: "Your order #{id} has been shipped", status: "success" }
      when "processed"
        { description: "Your purchase for order #{id} has been processed", status: "success" }
      when "returning"
        { description: "Your order #{id} has been accepted for return. We will update you when it has been received.", status: "success" }
      end

    send_notification(notification_details) unless notification_details.nil?
  end

private

  def expected_delivery_date_after_created_at
    return if created_at.blank?

    if %w[pending cancelled delivered returned returning].include?(status)
      self.expected_delivery_date = nil if expected_delivery_date.present?
      nil
    elsif !expected_delivery_date.nil? && expected_delivery_date <= created_at.to_date
      errors.add(:expected_delivery_date, "must be after the order creation date and not blank for statuses other than pending, cancelled, delivered, returned, or returning")
      throw :abort
    end
  end

  def send_order_created_notification
    CreateNotificationJob.perform_later(user: user, notifiable: self, description: "Your order has been created", status: "success")
  end

  def send_notification(details)
    CreateNotificationJob.perform_later(user: user, notifiable: self, description: details[:description], status: details[:status])
  end
end
