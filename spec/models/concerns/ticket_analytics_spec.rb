# spec/models/ticket_analytics_spec.rb
require 'rails_helper'

RSpec.describe Ticket, type: :model do
  describe "TicketAnalytics" do
    describe ".total" do
      it "returns the total count of tickets" do
        expect(Ticket.total).to eq(Ticket.count)
      end
    end

    describe ".by_type" do
      it "returns tickets of a specific type" do
        type = "Issue"

        expect(Ticket.by_type(type).count).to eq(Ticket.where(ticket_type: type).count)
      end
    end

    describe ".by_overdue" do
      it "returns overdue tickets" do
        expect(Ticket.by_overdue.count).to eq(Ticket.where("process_by < ?", Date.today).count)
      end
    end

    describe ".escalated" do
      it "returns escalated tickets" do
        expect(Ticket.escalated.count).to eq(Ticket.where.not(status: [:new_ticket, :approved]).count)
      end
    end

    describe ".no_action_required" do
      it "returns tickets with no action required status" do
        expect(Ticket.no_action_required.count).to eq(Ticket.where(status: :no_action_required).count)
      end
    end

    describe ".new_ticket" do
      it "returns new tickets" do
        expect(Ticket.new_ticket.count).to eq(Ticket.where(status: :new_ticket).count)
      end
    end

    describe ".awaiting_feedback" do
      it "returns tickets awaiting feedback" do
        expect(Ticket.awaiting_feedback.count).to eq(Ticket.where(status: :awaiting_feedback).count)
      end
    end

    describe ".processing" do
      it "returns processing tickets" do
        expect(Ticket.processing.count).to eq(Ticket.where(status: :processing).count)
      end
    end

    describe ".approved" do
      it "returns approved tickets" do
        expect(Ticket.approved.count).to eq(Ticket.where(status: :approved).count)
      end
    end

    describe ".manager_feedback" do
      it "returns tickets requiring manager feedback" do
        expect(Ticket.manager_feedback.count).to eq(Ticket.where(status: :manager_feedback).count)
      end
    end
  end
end