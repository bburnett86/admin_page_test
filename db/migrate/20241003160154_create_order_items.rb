# frozen_string_literal: true

class CreateOrderItems < ActiveRecord::Migration[7.0]
  def change
    create_table :order_items do |t|
      t.string :order_id, null: false, index: true
      t.string :product_id, null: false, index: true
      t.string :status, null: false, default: "pending"
      t.decimal :current_price, precision: 10, scale: 2
      t.decimal :sale_price, precision: 10, scale: 2
      t.decimal :percentage_off, precision: 5, scale: 2
      t.decimal :cost, precision: 10, scale: 2

      t.timestamps
    end
  end
end
