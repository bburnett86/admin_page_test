# frozen_string_literal: true

OrderItem.find_each do |order_item|
  product = Product.find(order_item.product_id)
  cost = product.cost

  months_since_creation = ((Time.zone.now - order_item.created_at) / 2.months).to_i

  current_price = product.current_price
  percentage_off = product.percentage_off

  months_since_creation.times do
    current_price += 100
    percentage_off = [percentage_off - 3, 0].max
  end

  sale_price = current_price * (1 - percentage_off / 100.0)

  ProductPricingHistory.create!(
    product_id: order_item.product_id,
    order_item_id: order_item.id,
    order_id: order_item.order_id,
    current_price: current_price,
    sale_price: sale_price,
    percentage_off: percentage_off,
    cost: cost,
    created_at: order_item.created_at,
    updated_at: order_item.updated_at
  )
end

puts "Product pricing histories seeded"
