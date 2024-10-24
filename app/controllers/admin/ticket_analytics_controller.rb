# frozen_string_literal: true

module Admin
  class TicketAnalyticsController < ApplicationController
    before_action :validate_admin

    def sorted_tickets_by_status
      excluded_statuses = params[:status].split(",") if params[:status]
      timeframe = params[:timeframe].to_i if params[:timeframe]

      # Validate excluded_statuses
      return render json: { error: "Invalid status parameter" }, status: :bad_request if excluded_statuses && !excluded_statuses.all? { |status| Ticket.statuses.keys.include?(status) }

      render json: Ticket.sorted_tickets_by_status(excluded_statuses, timeframe)
    end

    def calculate_ticket_totals
      timeframe = params[:timeframe].to_i

      return render json: { error: "Invalid timeframe parameter" }, status: :bad_request if timeframe.nil? || !timeframe.is_a?(Integer)

      return render json: { error: "Invalid timeframe parameter" }, status: :bad_request if timeframe < 6 || timeframe > 12

      render json: Ticket.calculate_ticket_totals(timeframe)
    end
  end
end
