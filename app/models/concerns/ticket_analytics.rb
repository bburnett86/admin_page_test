module TicketAnalytics
  extend ActiveSupport::Concern

  class_methods do
		def total
			Ticket.all.count
		end
		
		def by_type(type)
			Ticket.where(ticket_type: type)
		end
	
		def by_overdue
			Ticket.where("process_by < ?", Date.today)
		end
	
		def escalated
			Ticket.where.not(status: [:new_ticket, :approved])
		end
	
		def no_action_required
			Ticket.where(status: :no_action_required)
		end
	
		def new_ticket
			Ticket.where(status: :new_ticket)
		end
	
		def awaiting_feedback
			Ticket.where(status: :awaiting_feedback)
		end
	
		def processing
			Ticket.where(status: :processing)
		end
	
		def approved
			Ticket.where(status: :approved)
		end
	
		def manager_feedback
			Ticket.where(status: :manager_feedback)
		end
	end
end