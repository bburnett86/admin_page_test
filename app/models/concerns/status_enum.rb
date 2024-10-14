# frozen_string_literal: true

# app/models/concerns/status_enum.rb
module StatusEnum
  extend ActiveSupport::Concern

  included do
    enum :status, {
      add_to_cart: "add_to_cart",
      shopping_cart: "shopping_cart",
      payment_methods: "payment_methods",
      delivery_methods: "delivery_methods",
      confirm_order: "confirm_order",
      pending: "pending",
      processed: "processed",
      shipped: "shipped",
      cancelled: "cancelled",
      delivered: "delivered",
      returned: "returned",
      delayed: "delayed",
      returning: "returning",
    }, _prefix: true, default: :add_to_cart, validate: true
  end

  class_methods do
    def format_status(status)
      status.to_s.split("_").map(&:capitalize).join(" ")
    end
  end
end
