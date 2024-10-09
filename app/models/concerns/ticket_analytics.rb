module TicketAnalytics
  extend ActiveSupport::Concern

  class_methods do
    def all_tickets_by_status
      status_hash = {}
      Ticket.statuses.keys.map do |status|
        status_hash[status] = Ticket.where(status: status)
      end
      status_hash
    end

    def all_tickets_by_type
      type_hash = {}
      Ticket.ticket_types.keys.map do |type|
        type_hash[type] = Ticket.where(ticket_type: type)
      end
      type_hash
    end

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