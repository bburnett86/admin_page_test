# frozen_string_literal: true

# Load seed files in the specified order
seed_files = %w[
  users
  products
  orders
  order_items
  tickets
  notifications
]

seed_files.each do |seed|
  load Rails.root.join("db", "seeds", "#{seed}.rb")
end
