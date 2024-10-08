# spec/models/ticket_spec.rb
require 'rails_helper'

RSpec.describe Ticket, type: :model do
	fixtures :tickets, :users, :products

  # Associations
  describe 'associations' do
    it { should belong_to(:ticketable) }
    it { should belong_to(:creator).class_name('User') }
    it { should belong_to(:assigned_to).class_name('User').optional }
    it { should have_many(:notifications) }
  end

  # Validations
  describe 'validations' do
    it { should validate_presence_of(:description) }
    it { should validate_length_of(:description).is_at_least(5).is_at_most(255) }
    it { should validate_presence_of(:status) }
    it { should validate_presence_of(:ticket_type) }
    it { should validate_presence_of(:process_by) }
  end

  # Methods
  describe '#item_related_tickets' do
    let(:ticket) { tickets(:ticket_new_missing_part) }
    it 'returns tickets related to the same ticketable entity' do
      expect(ticket.item_related_tickets).to match_array([])
    end
  end

  # Enums
  describe 'enums' do
    let(:ticket) { Ticket.new }

    context 'status enum' do
      it 'responds to status enum methods' do
        expect(ticket).to respond_to(:status_new_ticket?)
        expect(ticket).to respond_to(:status_manager_feedback?)
        expect(ticket).to respond_to(:status_processing?)
        expect(ticket).to respond_to(:status_awaiting_feedback?)
        expect(ticket).to respond_to(:status_approved?)
        expect(ticket).to respond_to(:status_no_action_required?)

        expect(ticket).to respond_to(:status_new_ticket!)
        expect(ticket).to respond_to(:status_manager_feedback!)
        expect(ticket).to respond_to(:status_processing!)
        expect(ticket).to respond_to(:status_awaiting_feedback!)
        expect(ticket).to respond_to(:status_approved!)
        expect(ticket).to respond_to(:status_no_action_required!)
      end

      it 'can change the status' do
        ticketable = products(:product_one)
        user = users(:standard_user_one)
        ticket = Ticket.new(ticketable: ticketable, status: 'new_ticket', ticket_type: 'missing_part', active: true, creator: user, process_by: 2.weeks.from_now, description: 'Test ticket')
        ticket.status_processing!
        expect(ticket.status).to eq('processing')
        expect(ticket).to be_status_processing
      end
    end

    context 'ticket_type enum' do
      it 'responds to ticket_type enum methods' do
        ticketable = products(:product_one)
        user = users(:standard_user_one)
        ticket = Ticket.new(ticketable: ticketable, status: 'new_ticket', ticket_type: 'missing_part', active: true, creator: user, process_by: 2.weeks.from_now, description: 'Test ticket')
        expect(ticket).to respond_to(:ticket_type_missing_part?)
        expect(ticket).to respond_to(:ticket_type_not_performing_as_expected?)
        expect(ticket).to respond_to(:ticket_type_unexpected_outcome?)
        expect(ticket).to respond_to(:ticket_type_needs_technical_solution?)
        expect(ticket).to respond_to(:ticket_type_doesnt_match_description?)
        expect(ticket).to respond_to(:ticket_type_other?)

        expect(ticket).to respond_to(:ticket_type_missing_part!)
        expect(ticket).to respond_to(:ticket_type_not_performing_as_expected!)
        expect(ticket).to respond_to(:ticket_type_unexpected_outcome!)
        expect(ticket).to respond_to(:ticket_type_needs_technical_solution!)
        expect(ticket).to respond_to(:ticket_type_doesnt_match_description!)
        expect(ticket).to respond_to(:ticket_type_other!)
      end

      it 'can change the ticket_type' do
        ticketable = products(:product_one)
        user = users(:standard_user_one)
        ticket = Ticket.new(ticketable: ticketable, status: 'new_ticket', ticket_type: 'missing_part', active: true, creator: user, process_by: 2.weeks.from_now, description: 'Test ticket')
        ticket.ticket_type_needs_technical_solution!
        expect(ticket.ticket_type).to eq('needs_technical_solution')
        expect(ticket).to be_ticket_type_needs_technical_solution
      end
    end
  end

  # Callbacks
  describe 'callbacks' do

    it 'calls update_assigned_to_notification after create if assigned_to is present' do
			ticket = tickets(:ticket_new_missing_part)
      expect(ticket).to receive(:update_assigned_to_notification)
      ticket.assigned_to = users(:admin_user_one)
      ticket.run_callbacks(:create)
    end

    it 'calls handle_status_change after update if status changed' do
			ticket = tickets(:ticket_new_missing_part)
      expect(ticket).to receive(:handle_status_change)
      ticket.status = 'approved'
      ticket.run_callbacks(:update)
    end
  end
end