describe "TicketAnalytics" do
  describe ".tickets_by_status" do
    it "returns tickets with status :new_ticket" do
      expect(Ticket.tickets_by_status(:new_ticket).count).to eq(Ticket.where(status: :new_ticket).count)
    end

    it "returns tickets with status :awaiting_feedback" do
      expect(Ticket.tickets_by_status(:awaiting_feedback).count).to eq(Ticket.where(status: :awaiting_feedback).count)
    end

    it "returns tickets with status :processing" do
      expect(Ticket.tickets_by_status(:processing).count).to eq(Ticket.where(status: :processing).count)
    end

    it "returns tickets with status :approved" do
      expect(Ticket.tickets_by_status(:approved).count).to eq(Ticket.where(status: :approved).count)
    end

    it "returns tickets with status :manager_feedback" do
      expect(Ticket.tickets_by_status(:manager_feedback).count).to eq(Ticket.where(status: :manager_feedback).count)
    end

    it "returns tickets with status :no_action_required" do
      expect(Ticket.tickets_by_status(:no_action_required).count).to eq(Ticket.where(status: :no_action_required).count)
    end
  end
end