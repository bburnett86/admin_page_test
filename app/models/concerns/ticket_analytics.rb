module TicketAnalytics
  extend ActiveSupport::Concern

  class_methods do
    def total
      Ticket.all.count
    end
    
    def tickets_by_type(type)
      Ticket.where(ticket_type: type)
    end

    def tickets_by_status(status)
      Ticket.where(status: status)
    end

    def by_overdue
      Ticket.where("process_by < ?", Date.today)
    end

    def escalated
      Ticket.where.not(status: [:new_ticket, :approved])
    end
  end
end