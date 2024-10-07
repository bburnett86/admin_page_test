class Ticket < ApplicationRecord
  include TicketAnalytics
  enum :ticket_status, {
    new_ticket: 'new_ticket',
    manager_feedback: 'manager_feedback',
    processing: 'processing',
    awaiting_feedback: 'awaiting_feedback',
    approved: 'approved',
    no_action_required: 'no_action_required'
  }, default: :new_ticket, _prefix: true, validate: true

  enum :ticket_type, {
    missing_part: 'missing_part',
    not_performing_as_expected: 'not_performing_as_expected',
    unexpected_outcome: 'unexpected_outcome',
    needs_technical_solution: 'needs_technical_solution',
    doesnt_match_description: 'doesnt_match_description',
    other: 'other'
  }, default: :other, _prefix: true,  validate: true

  belongs_to :ticketable, polymorphic: true
  belongs_to :creator, class_name: 'User'
  belongs_to :assigned_to, class_name: 'User', optional: true
  has_many :notifications, as: :notifiable

  after_create :create_creator_notification
  after_update :handle_status_change, if: :saved_change_to_status?

  validates :description, presence: true, length: {minimum: 5, maximum: 255}
  validates :status, presence: true
  validates :ticket_type, presence: true
  validates :process_by, presence: true

  def item_related_tickets
    Ticket.where(ticketable: self.ticketable)
  end

  def handle_status_change
    notification_details = 
      case status
      when 'approved'
        update_user_resolved
        nil # Explicitly return nil as no notification needs to be sent here
      when 'manager_feedback'
        { description: "Your ticket's status has been updated to #{status} and we are working diligently to resolve your issue", status: "success", user: creator }
      else
        unless ['new_ticket', 'approved', 'manager_feedback'].include?(status)
          { description: "Ticket number ##{id} has been updated to #{status}. Please review and provide feedback. It's current expected date of processing is #{process_by.strftime("%Y-%m-%d")}", status: "success", user: assigned_to }
        end
      end
  
    send_update_notification(notification_details) if notification_details
  end
  
  private

  def status_formatter(status)
    status.gsub("_", " ").titleize
  end

  def create_assigned_to_notification
    formatted_process_by = self.process_by.strftime("%Y-%m-%d")

    CreateNotificationJob.perform_later(user: self.creator, notifiable: self, description: "Ticket number ##{self.id} has been assigned to you. It is expected to be processed by #{formatted_process_by}", status: "success")
  end

  def create_creator_notification
    CreateNotificationJob.perform_later(user: self.creator, notifiable: self, description: "Ticket has been created and will be attended to as soon as possible.", status: "success")
  end

  def send_update_notification(details)
    CreateNotificationJob.perform_later(user: details[:user] || user, notifiable: self, description: details[:description], status: details[:status])
  end

  def update_user_resolved
    CreateNotificationJob.perform_later(user: self.creator, notifiable: self, description: "Ticket number ##{self.id} has been resolved", status: "success")
  end
end
