Order.find_each do |order|
  number_of_items = rand(3..10)

  number_of_items.times do
    product = Product.order("RANDOM()").first

    status = 
      if order.status == 'delivered' && rand(1..5) == 1
        'returned'
      else
        order.status
      end

    OrderItem.create!(
      order_id: order.id,
      product_id: product.id,
      status: status,
      created_at: order.created_at,
      updated_at: order.updated_at,
      cost: product.cost,
      current_price: product.current_price,
      sale_price: product.sale_price,
      percentage_off: product.percentage_off,
      expected_delivery_date: order.expected_delivery_date,
    )
  end
end

puts "Order items seeded"