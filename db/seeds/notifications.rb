def random_date_within_last_8_months
  end_date = Time.now
  start_date = 8.months.ago
  Time.at((start_date.to_f - end_date.to_f)*rand + end_date.to_f)
end

def determine_status_based_on_age(created_at)
  if created_at < 3.months.ago
    "archived"
  elsif created_at < 1.month.ago
    "read"
  else
    "new_notification"
  end
end

Ticket.find_each do |ticket|
  date = random_date_within_last_8_months
  notification_status = determine_status_based_on_age(date)
  creator, notifiable, description, status = case ticket.status
  when 'approved'
    [ticket.creator, ticket, "Ticket number ##{ticket.id} has been resolved", "success"]
  when 'manager_feedback'
    formatted_process_by = ticket.process_by.strftime("%Y-%m-%d")
    [ticket.creator, ticket, "Ticket number ##{ticket.id} has been updated to #{ticket.status}. Please review and provide feedback. It's current expected date of processing is #{formatted_process_by}", "success"]
  else
    unless ['new', 'approved', 'manager_feedback'].include?(ticket.status)
      formatted_process_by = ticket.process_by.strftime("%Y-%m-%d")
      [ticket.assigned_to, ticket, "Ticket number ##{ticket.id} has been updated to #{ticket.status}. Please review and provide feedback. It's current expected date of processing is #{formatted_process_by}", "success"]
    end
  end

  if creator
    Notification.create!(
      user: creator,
      notifiable: notifiable,
      description: description,
      status: notification_status
    )
  end
end

OrderItem.find_each do |order_item|
  date = random_date_within_last_8_months
  notification_status = determine_status_based_on_age(date)
  user, notifiable, description, status = case order_item.status
  when 'delayed'
    new_delivery_date = (order_item.order.expected_delivery_date + 2.weeks).strftime("%Y-%m-%d")
    [order_item.order.user, order_item, "Your order has been delayed. It is now expected to arrive by #{new_delivery_date}.", "warning"]
  when 'cancelled'
    order = order_item.order
    product_name = order_item.product.name
    [order_item.order.user, order_item, "On order #{order.id} item #{product_name} has been cancelled", "error"]
  when 'returning'
    order = order_item.order
    product_name = order_item.product.name
    [order_item.order.user, order_item, "On order #{order.id} the return of item #{product_name} has been accepted", "success"]
  when 'returned'
    order = order_item.order
    product_name = order_item.product.name
    [order_item.order.user, order_item, "On order #{order.id} item #{product_name} has been returned", "success"]
  end
  Notification.create!(user: user, notifiable: notifiable, description: description, status: notification_status) if user
end

Order.find_each do |order|
  date = random_date_within_last_8_months
  notification_status = determine_status_based_on_age(date)
  user, notifiable, description, status = case order.status
  when 'pending'
    [order.user, order, "Your order has been accepted, you will receive more updates soon.", "success"]
  when 'cancelled'
    [order.user, order, "Your order #{order.id} has been cancelled", "error"]
  when 'returned'
    [order.user, order, "Your order #{order.id} has been returned", "success"]
  when 'delayed'
    new_delivery_date = (order.expected_delivery_date + 2.weeks).strftime("%Y-%m-%d") 
    [order.user, order, "Your order #{order.id} has been delayed. It is now expected to arrive by #{new_delivery_date}.", "warning"]
  when 'delivered'
    [order.user, order, "Your order #{order.id} has been delivered", "success"]
  when 'shipped'
    [order.user, order, "Your order #{order.id} has been shipped", "success"]
  end
  Notification.create!(user: user, notifiable: notifiable, description: description, status: notification_status) if user
end

puts 'Notifications seeded'