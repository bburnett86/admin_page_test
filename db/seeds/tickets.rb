non_admin_users = User.where.not(role: 'admin')
admin_users = User.where(role: "admin")

600.times do
  description = Faker::Lorem.paragraph(sentence_count: 2)
	status = %w[new_ticket manager_feedback processing awaiting_feedback approved no_action_required].sample
	date = rand(8.months).seconds.ago
  new_date = date + 2.weeks
  ticket = Ticket.new(
    ticketable: OrderItem.order("RANDOM()").first,
    status: status,
    ticket_type: %w[missing_part not_performing_as_expected unexpected_outcome needs_technical_solution doesnt_match_description other].sample,
    creator: non_admin_users.sample,
    assigned_to: admin_users.sample,
    description: description,
    process_by: new_date,
    created_at: date,
    updated_at: date
  )
  ticket.active = !%w[no_action_required approved].include?(ticket.status)
  ticket.save!
end

200.times do
  description = Faker::Lorem.paragraph(sentence_count: 2)
	status = %w[new_ticket manager_feedback processing awaiting_feedback approved no_action_required].sample
	date = rand(8.months).seconds.ago
  new_date = date + 2.weeks
  ticket = Ticket.new(
    ticketable: Order.order("RANDOM()").first,
    status: status,
    ticket_type: %w[missing_part not_performing_as_expected unexpected_outcome needs_technical_solution doesnt_match_description other].sample,
    creator: non_admin_users.sample,
    assigned_to: admin_users.sample,
    description: description,
    process_by: new_date,
    created_at: date,
    updated_at: date
  )
  ticket.active = !%w[no_action_required approved].include?(ticket.status)
  ticket.save!
end

200.times do
  description = Faker::Lorem.paragraph(sentence_count: 2)
	status = %w[new_ticket manager_feedback processing awaiting_feedback approved no_action_required].sample
	date = rand(8.months).seconds.ago
  new_date = date + 2.weeks
  ticket = Ticket.new(
    ticketable: Product.order("RANDOM()").first,
    status: status,
    ticket_type: %w[missing_part not_performing_as_expected unexpected_outcome needs_technical_solution doesnt_match_description other].sample,
    creator: non_admin_users.sample,
    assigned_to: admin_users.sample,
    description: description,
    process_by: new_date,
    created_at: date,
    updated_at: date
  )
  ticket.active = !%w[no_action_required approved].include?(ticket.status)
  ticket.save!
end

puts "Tickets seeded"