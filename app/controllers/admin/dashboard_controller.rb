# frozen_string_literal: true

module Admin
  class DashboardController < ApplicationController
    # before_action :validate_admin
    
    def index
      @line_chart_data = Product.calculate_multiple_finance_line_graph_metrics
      this_weeks_escalations = Ticket.sorted_tickets_by_status(%w[closed no_action_required])
      @new_tickets = this_weeks_escalations["new_ticket"]
      @manager_feedback = this_weeks_escalations["manager_feedback"]
      @processing = this_weeks_escalations["processing"]
      @awaiting_feedback = this_weeks_escalations["awaiting_feedback"]
      @approved = this_weeks_escalations["approved"]
      @pipeline_chart_data = Product.calculate_pipeline_chart_metrics(:pending)
      @icon_grid_data = Ticket.calculate_ticket_totals(12)
    end
  end
end