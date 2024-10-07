class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.string :status, null: false, default: 'processed'
      t.string :user_id, null: false, index: true
      t.date :expected_delivery_date, default: -> { 'CURRENT_DATE' }

      t.timestamps
    end
  end
end