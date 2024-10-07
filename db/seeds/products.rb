40.times do
  unique_name = false
  name = ''

  while !unique_name
    name = Faker::Commerce.product_name
    unique_name = !Product.exists?(name: name)
  end

  description = Faker::Lorem.paragraph(sentence_count: 2)
  inventory_count = rand(1000..5000)
  current_price_options = (1..20).map { |n| n * 100.0 + 99.99 }
  current_price = current_price_options.sample
  cost = current_price * rand(0.15..0.4).round(2)
  percentage_off = rand(5..35)
  sale_price = current_price * (1 - percentage_off / 100.0)

  Product.create!(
    name: name,
    description: description,
    inventory_count: inventory_count,
    active: true,
    current_price: current_price,
    cost: cost,
    percentage_off: percentage_off,
    sale_price: sale_price
  )
end

puts "Products seeded"