# frozen_string_literal: true

class AddExpectedDeliveryDateToOrderItems < ActiveRecord::Migration[7.0]
  def change
    add_column :order_items, :expected_delivery_date, :datetime
  end
end
