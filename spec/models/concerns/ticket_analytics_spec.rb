# frozen_string_literal: true

# spec/models/concerns/ticket_analytics_spec.rb
require "rails_helper"

RSpec.describe TicketAnalytics, type: :model do
  describe "Public methods" do
    describe ".sorted_tickets_by_status" do
      it "returns all tickets sorted by status when no parameters are given" do
        expect(Ticket.sorted_tickets_by_status).to match_array(Ticket.all.group_by(&:status))
      end

      it "excludes specified statuses" do
        excluded_statuses = ["new_ticket"]
        expect(Ticket.sorted_tickets_by_status(excluded_statuses)).not_to include("new_ticket")
      end

      it "raises an error if excluded_statuses is not an array" do
        expect { Ticket.sorted_tickets_by_status("new_ticket") }.to raise_error(ArgumentError)
      end
    end

    describe ".sorted_tickets_by_type" do
      it "returns all tickets sorted by type when no parameters are given" do
        expect(Ticket.sorted_tickets_by_type).to match_array(Ticket.all.group_by(&:ticket_type))
      end

      it "excludes specified types" do
        excluded_types = ["bug"]
        expect(Ticket.sorted_tickets_by_type(excluded_types)).not_to include("bug")
      end

      it "raises an error if excluded_types is not an array" do
        expect { Ticket.sorted_tickets_by_type("bug") }.to raise_error(ArgumentError)
      end
    end

    describe ".calculate_ticket_totals" do
      context "without timeframe" do
        it "calculates totals correctly" do
          totals = Ticket.calculate_ticket_totals
          expect(totals[:total]).to eq(Ticket.count)
          expect(totals[:overdue]).to eq(Ticket.where("process_by < ?", Date.today).count)
          expect(totals[:closed_without_feedback]).to eq(Ticket.where(status: :no_action_required).count)
          expect(totals[:escalated]).to eq(Ticket.where.not(status: %i[no_action_required closed]).count)
        end
      end

      context "with timeframe" do
        it "calculates totals correctly" do
          timeframe = 30 # days
          totals = Ticket.calculate_ticket_totals(timeframe)
          filtered_tickets = Ticket.where("created_at >= ?", Time.now - timeframe.days)
          expect(totals[:total]).to eq(filtered_tickets.count)
          expect(totals[:overdue]).to eq(filtered_tickets.where("process_by < ?", Date.today).count)
          expect(totals[:closed_without_feedback]).to eq(filtered_tickets.where(status: :no_action_required).count)
          expect(totals[:escalated]).to eq(filtered_tickets.where.not(status: %i[no_action_required closed]).count)
        end
      end
    end
  end

  describe "Private methods" do
    describe "#total" do
      it "returns the total number of tickets" do
        expect(Ticket.send(:total)).to eq(Ticket.count)
      end
    end

    describe "#by_overdue" do
      it "returns the count of overdue tickets" do
        overdue_tickets_count = Ticket.where("process_by < ?", Date.today).count
        expect(Ticket.send(:by_overdue)).to eq(overdue_tickets_count)
      end
    end

    describe "#by_closed_without_feedback" do
      it "returns the count of tickets closed without feedback" do
        tickets_count = Ticket.where(status: :no_action_required).count
        expect(Ticket.send(:by_closed_without_feedback)).to eq(tickets_count)
      end
    end

    describe "#by_escalated" do
      it "returns the count of escalated tickets" do
        escalated_tickets_count = Ticket.where.not(status: %i[no_action_required closed]).count
        expect(Ticket.send(:by_escalated)).to eq(escalated_tickets_count)
      end
    end

    describe "#filter_by_timeframe" do
      it "filters tickets by the given timeframe" do
        timeframe = 30 # days
        filtered_tickets = Ticket.where("created_at >= ?", Time.now - timeframe.days)
        expect(Ticket.send(:filter_by_timeframe, Ticket.all, timeframe)).to match_array(filtered_tickets)
      end

      it "returns all tickets if timeframe is nil" do
        expect(Ticket.send(:filter_by_timeframe, Ticket.all, nil)).to match_array(Ticket.all)
      end
    end
  end
end
