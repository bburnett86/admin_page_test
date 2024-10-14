# frozen_string_literal: true

module TicketAnalytics
  extend ActiveSupport::Concern

  class_methods do
    def sorted_tickets_by_status(excluded_statuses = nil, timeframe = nil)
      raise ArgumentError, "excluded_statuses must be an array" if !excluded_statuses.nil? && !excluded_statuses.is_a?(Array)

      res = {}
      Ticket.statuses.keys.each do |status|
        next if excluded_statuses&.include?(status)

        tickets = Ticket.where(status: status)
        tickets = tickets.where("created_at >= ?", Time.now - timeframe.days) if timeframe
        res[status] = tickets.to_a unless tickets.empty?
      end

      res
    end

    def sorted_tickets_by_type(excluded_types = nil, timeframe = nil)
      raise ArgumentError, "excluded_types must be an array" if excluded_types && !excluded_types.is_a?(Array)

      res = {}
      Ticket.ticket_types.keys.each do |type|
        next if excluded_types&.include?(type)

        tickets = Ticket.where(ticket_type: type)
        tickets = tickets.where("created_at >= ?", Time.now - timeframe.days) if timeframe
        res[type] = tickets
      end

      res
    end

    def calculate_ticket_totals(timeframe = nil)
      {
        total: total,
        overdue: by_overdue(timeframe),
        closed_without_feedback: by_closed_without_feedback(timeframe),
        escalated: by_escalated(timeframe),
      }
    end

  private

    def total
      Ticket.count
    end

    def by_overdue(timeframe = nil)
      tickets = Ticket.where("process_by < ?", Date.today)
      filter_by_timeframe(tickets, timeframe).count
    end

    def by_closed_without_feedback(timeframe = nil)
      tickets = Ticket.where(status: :no_action_required)
      filter_by_timeframe(tickets, timeframe).count
    end

    def by_escalated(timeframe = nil)
      tickets = Ticket.where.not(status: %i[no_action_required closed])
      filter_by_timeframe(tickets, timeframe).count
    end

    def filter_by_timeframe(tickets, timeframe)
      timeframe ? tickets.where("created_at >= ?", Time.now - timeframe.days) : tickets
    end
  end
end
