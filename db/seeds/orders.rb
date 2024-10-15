# frozen_string_literal: true

non_admin_users = User.where.not(role: "admin")

non_admin_users.each do |user|
  25.times do
    created_at_datetime = Faker::Time.between(from: 8.months.ago, to: Time.now, format: :default).to_datetime
    expected_delivery_date = nil

    status =
      if (Date.today - created_at_datetime.to_date).to_i > 45
        %w[delivered cancelled returned].sample
      elsif (Date.today - created_at_datetime.to_date).to_i > 30
        %w[delayed returning delivered cancelled returning ].sample # Removed duplicate 'returning'
      else
        %w[pending shipped processed add_to_cart shopping_cart payment_methods delivery_methods confirm_order].sample
      end

    case status
    when "processed"
      expected_delivery_date = created_at_datetime + 17.days
    when "shipping"
      expected_delivery_date = created_at_datetime + 14.days
    when "delayed", "cancelled", "delivered", "returned", "returning"
      expected_delivery_date = created_at_datetime + 8.days
    when "add_to_cart", "shopping_cart", "payment_methods", "delivery_methods", "confirm_order", "pending"
      expected_delivery_date = nil
    end

    user.orders.create!(
      status: status,
      created_at: created_at_datetime,
      updated_at: DateTime.now,
      expected_delivery_date: expected_delivery_date
    )
  end
end

puts "Orders seeded"
