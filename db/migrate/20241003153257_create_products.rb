# frozen_string_literal: true

class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :name, null: false, index: true
      t.string :description, null: false
      t.float :cost, null: false
      t.integer :inventory_count, null: false, default: 0
      t.decimal :current_price, precision: 10, scale: 2
      t.decimal :sale_price, precision: 10, scale: 2
      t.decimal :percentage_off, precision: 5, scale: 2

      t.timestamps
    end
  end
end
